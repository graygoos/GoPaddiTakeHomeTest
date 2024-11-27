//
//  TripDetailsViewModel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

class TripDetailsViewModel: ObservableObject {
    @Published var trip: Trip
    @Published var flights: [Flight] = []
    @Published var hotels: [Hotel] = []
    @Published var activities: [Activity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    private let tripStore = TripStore.shared
    private let apiService: APIServiceProtocol
    private var updateTask: Task<Void, Never>?
    
    init(trip: Trip, apiService: APIServiceProtocol = APIService.shared) {
        self.trip = trip
        self.apiService = apiService
        self.flights = trip.flights ?? []
        self.hotels = trip.hotels ?? []
        self.activities = trip.activities ?? []
    }
    
    @MainActor
    private func updateTripWithAPI() async {
        guard !Task.isCancelled else { return }
        
        isLoading = true
        
        do {
            // Create updated trip with current collections
            var updatedTrip = trip
            updatedTrip.flights = flights
            updatedTrip.hotels = hotels
            updatedTrip.activities = activities
            
            // Try to update via API
            let apiUpdatedTrip = try await apiService.updateTrip(updatedTrip)
            self.trip = apiUpdatedTrip
            tripStore.updateTrip(apiUpdatedTrip)
        } catch {
            // On API failure, update local storage only
            var updatedTrip = trip
            updatedTrip.flights = flights
            updatedTrip.hotels = hotels
            updatedTrip.activities = activities
            tripStore.updateTrip(updatedTrip)
            
            errorMessage = "Changes saved locally only due to API error"
            showError = true
        }
        
        isLoading = false
    }
    
    @MainActor
    func deleteTrip() async -> Bool {
        isLoading = true
        
        do {
            try await apiService.deleteTrip(trip.id)
            tripStore.deleteTrip(trip.id)
            isLoading = false
            return true
        } catch {
            // On API failure, still delete locally
            tripStore.deleteTrip(trip.id)
            errorMessage = "Trip deleted locally only due to API error"
            showError = true
            isLoading = false
            return true // Still return true to dismiss the view
        }
    }
    
    func updateTripWithCurrentState() {
        // Cancel any pending update
        updateTask?.cancel()
        
        // Create new update task with debounce
        updateTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second debounce
            await updateTripWithAPI()
        }
    }
    
    // MARK: - Collection Management
    func addFlight(_ flight: Flight) {
        flights.append(flight)
        updateTripWithCurrentState()
    }
    
    func addHotel(_ hotel: Hotel) {
        hotels.append(hotel)
        updateTripWithCurrentState()
    }
    
    func addActivity(_ activity: Activity) {
        activities.append(activity)
        updateTripWithCurrentState()
    }
    
    func removeFlight(at indexSet: IndexSet) {
        flights.remove(atOffsets: indexSet)
        updateTripWithCurrentState()
    }
    
    func removeHotel(at indexSet: IndexSet) {
        hotels.remove(atOffsets: indexSet)
        updateTripWithCurrentState()
    }
    
    func removeActivity(at indexSet: IndexSet) {
        activities.remove(atOffsets: indexSet)
        updateTripWithCurrentState()
    }
}
