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
    
    // API-related states
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    private let tripStore = TripStore.shared
    private let apiService: APIService
    private var updateTask: Task<Void, Never>?
    
    init(trip: Trip, apiService: APIService = APIService.shared) {
        self.trip = trip
        self.apiService = apiService
        self.flights = trip.flights ?? []
        self.hotels = trip.hotels ?? []
        self.activities = trip.activities ?? []
    }
    
    private func updateTripInAPI() {
        // Cancel any pending update
        updateTask?.cancel()
        
        // Create new update task
        updateTask = Task {
            // Add slight delay to debounce rapid updates
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            if Task.isCancelled { return }
            
            await updateTripWithAPI()
        }
    }
    
    @MainActor
    private func updateTripWithAPI() async {
        guard !Task.isCancelled else { return }
        
        isLoading = true
        
        do {
            let updatedTrip = try await apiService.updateTrip(trip)
            tripStore.updateTrip(updatedTrip)
            self.trip = updatedTrip
            
            // Update local store even if API fails
            tripStore.updateTrip(trip)
        } catch let error as APIError {
            errorMessage = error.userMessage
            showError = true
            
            // Log error for debugging
            print("Update trip error: \(error.userMessage)")
        } catch {
            errorMessage = "An unexpected error occurred"
            showError = true
            
            // Log error for debugging
            print("Unexpected error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func updateTripWithCurrentState() {
        var updatedTrip = trip
        updatedTrip.flights = flights
        updatedTrip.hotels = hotels
        updatedTrip.activities = activities
        trip = updatedTrip
        
        // Update local store immediately
        tripStore.updateTrip(trip)
        
        // Trigger API update
        updateTripInAPI()
    }
    
    @MainActor
    func deleteTrip() async -> Bool {
        isLoading = true
        
        do {
            try await apiService.deleteTrip(trip.id)
            tripStore.deleteTrip(trip.id)
            isLoading = false
            return true
        } catch let error as APIError {
            errorMessage = error.userMessage
            showError = true
            isLoading = false
            return false
        } catch {
            errorMessage = "An unexpected error occurred"
            showError = true
            isLoading = false
            return false
        }
    }
    
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
