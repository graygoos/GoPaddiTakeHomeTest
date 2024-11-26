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
    private let apiService = APIService.shared
    
    var currentTripName: String = ""
    var currentTripStyle: TravelStyle = .solo
    var currentTripDescription: String = ""
    
    var canCreateTrip: Bool {
        selectedLocation != nil && tripDates.startDate != nil && tripDates.endDate != nil
    }
    
    @MainActor
    func createDetailedTrip(name: String, travelStyle: TravelStyle, description: String) {
        Task {
            isLoading = true
            
            do {
                let newTrip = Trip(
                    id: UUID().uuidString,
                    name: name,
                    destination: "\(selectedLocation?.name ?? ""), \(selectedLocation?.country ?? "")",
                    date: tripDates.startDate ?? Date(),
                    endDate: tripDates.endDate,
                    details: description,
                    price: 0.0,
                    images: [],
                    location: selectedLocation,
                    travelStyle: travelStyle,
                    flights: [],
                    hotels: [],
                    activities: []
                )
                
                let createdTrip = try await apiService.createTrip(newTrip)
                trips.insert(createdTrip, at: 0)
                tripStore.trips = trips
                tripStore.saveTrips()
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
    
    @MainActor
    func fetchTrips() {
        Task {
            do {
                isLoading = true
                let trips = try await apiService.fetchTrips()
                self.trips = trips
            } catch let error as APIError {
                errorMessage = error.userMessage
                showError = true
            } catch {
                errorMessage = "Network error: The data couldn't be read because it isn't in the correct format."
                showError = true
            }
            isLoading = false
        }
    }
    
    private func resetFormData() {
        selectedLocation = nil
        tripDates = TripDate()
        currentTripName = ""
        currentTripStyle = .solo
        currentTripDescription = ""
    }
}
