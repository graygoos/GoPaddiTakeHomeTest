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
    }

    @MainActor
    func fetchTrips() async {
        do {
            isLoading = true
            let fetchedTrips = try await apiService.fetchTrips()
            trips = fetchedTrips
            tripStore.trips = fetchedTrips
            tripStore.saveTrips()
        } catch let error as APIError {
            errorMessage = error.userMessage
            showError = true
        } catch {
            errorMessage = "Failed to fetch trips"
            showError = true
        }
        isLoading = false
    }
    
    @MainActor
    func createDetailedTrip(name: String, travelStyle: TravelStyle, description: String) {
        guard let location = selectedLocation,
              let startDate = tripDates.startDate,
              let endDate = tripDates.endDate else {
            return
        }
        
        Task {
            do {
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
                
                let createdTrip = try await apiService.createTrip(newTrip)
                trips.insert(createdTrip, at: 0)
                tripStore.updateTrip(createdTrip)
                newlyCreatedTrip = createdTrip
                showTripDetail = true
                resetFormData()
                
            } catch let error as APIError {
                errorMessage = error.userMessage
                showError = true
            } catch {
                errorMessage = "An unexpected error occurred"
                showError = true
            }
            
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
