//
//  TripPlanningViewModel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

class TripPlanningViewModel: ObservableObject {
    @Published var showingPlannerOverlay = true
    @Published var selectedLocation: Location?
    @Published var tripDates = TripDate()
    @Published var showLocationPicker = false
    @Published var showDatePicker = false
    @Published var isSelectingEndDate = false
    @Published var showCreateTrip = false
    @Published var showTripDetail = false
    @Published var trips: [Trip] = []
    @Published var newlyCreatedTrip: Trip?
    
    // API-related states
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    private let tripStore = TripStore.shared
    private let apiService: APIServiceProtocol
    
    var canCreateTrip: Bool {
        selectedLocation != nil && tripDates.startDate != nil && tripDates.endDate != nil
    }
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
        // Load stored trips immediately
        self.trips = tripStore.trips
    }

    @MainActor
    func fetchTrips() async {
        do {
            isLoading = true
            let fetchedTrips = try await apiService.fetchTrips()
            
            // Merge API trips with local trips, avoiding duplicates
            var allTrips = tripStore.trips
            for apiTrip in fetchedTrips {
                if !allTrips.contains(where: { $0.id == apiTrip.id }) {
                    allTrips.append(apiTrip)
                }
            }
            
            trips = allTrips.sorted(by: { $0.date > $1.date })
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch remote trips. Showing local trips only."
            showError = true
            isLoading = false
            // Use local trips if API fails
            trips = tripStore.trips
        }
    }
    
    @MainActor
    func createDetailedTrip(name: String, travelStyle: TravelStyle, description: String) {
        guard let location = selectedLocation,
              let startDate = tripDates.startDate,
              let endDate = tripDates.endDate else {
            return
        }
        
        Task {
            isLoading = true
            
            let newTrip = Trip(
                id: UUID().uuidString,
                name: name,
                destination: "\(location.name), \(location.country)",
                date: startDate,
                endDate: endDate,
                details: description,
                price: 0.0,
                images: [],
                location: location,
                travelStyle: travelStyle,
                flights: [],
                hotels: [],
                activities: []
            )
            
            do {
                let createdTrip = try await apiService.createTrip(newTrip)
                // Update both local arrays
                trips.insert(createdTrip, at: 0)
                tripStore.updateTrip(createdTrip)
                newlyCreatedTrip = createdTrip
            } catch {
                // If API fails, use the local trip
                trips.insert(newTrip, at: 0)
                tripStore.updateTrip(newTrip)
                newlyCreatedTrip = newTrip
                errorMessage = "Trip saved locally only. Network error occurred."
                showError = true
            }
            
            showTripDetail = true
            resetFormData()
            isLoading = false
        }
    }
    
    private func resetFormData() {
        selectedLocation = nil
        tripDates = TripDate()
        showCreateTrip = false
        showingPlannerOverlay = false
    }
}
