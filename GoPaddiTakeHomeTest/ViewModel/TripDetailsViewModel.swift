//
//  TripDetailsViewModel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - TripDetailsViewModel
/// ViewModel for managing trip details, including flights, hotels, and activities
class TripDetailsViewModel: ObservableObject {
    // MARK: - Published Properties
    /// Current trip being managed
    @Published var trip: Trip
    /// List of flights associated with the trip
    @Published var flights: [Flight] = []
    /// List of hotels associated with the trip
    @Published var hotels: [Hotel] = []
    /// List of activities associated with the trip
    @Published var activities: [Activity] = []
    /// Loading state indicator
    @Published var isLoading = false
    /// Error message for displaying to user
    @Published var errorMessage: String?
    /// Flag to control error alert visibility
    @Published var showError = false
    
    // MARK: - Private Properties
    /// Local storage manager for trips
    private let tripStore = TripStore.shared
    /// Service for API interactions
    private let apiService: APIServiceProtocol
    /// Task for managing debounced updates
    private var updateTask: Task<Void, Never>?
    
    // MARK: - Initialization
    /// Initializes the view model with a trip and optional API service
    /// - Parameters:
    ///   - trip: The trip to be managed
    ///   - apiService: Service for API interactions, defaults to shared instance
    init(trip: Trip, apiService: APIServiceProtocol = APIService.shared) {
        self.trip = trip
        self.apiService = apiService
        self.flights = trip.flights ?? []
        self.hotels = trip.hotels ?? []
        self.activities = trip.activities ?? []
    }
    
    // MARK: - Private Methods
    /// Updates the trip data through the API with error handling and local fallback
    /// - Note: Updates are executed on the main actor to ensure UI updates are thread-safe
    @MainActor
    private func updateTripWithAPI() async {
        guard !Task.isCancelled else { return }
        
        isLoading = true
        
        var updatedTrip = trip
        updatedTrip.flights = flights
        updatedTrip.hotels = hotels
        updatedTrip.activities = activities
        
        do {
            _ = try await apiService.updateTrip(updatedTrip)
            self.trip = updatedTrip
            tripStore.updateTrip(updatedTrip)
        } catch {
            // Fallback to local storage on API failure
            self.trip = updatedTrip
            tripStore.updateTrip(updatedTrip)
            errorMessage = "Changes saved locally only due to API error"
            showError = true
        }
        
        isLoading = false
    }
    
    // MARK: - Public Methods - Trip Item Management
    /// Adds a new flight to the trip
    /// - Parameter flight: The flight to add
    func addFlight(_ flight: Flight) {
        flights.append(flight)
        let updatedTrip = trip
        tripStore.updateTrip(updatedTrip)
        updateTripWithCurrentState()
    }
    
    /// Adds a new hotel to the trip
    /// - Parameter hotel: The hotel to add
    func addHotel(_ hotel: Hotel) {
        hotels.append(hotel)
        let updatedTrip = trip
        tripStore.updateTrip(updatedTrip)
        updateTripWithCurrentState()
    }
    
    /// Adds a new activity to the trip
    /// - Parameter activity: The activity to add
    func addActivity(_ activity: Activity) {
        activities.append(activity)
        let updatedTrip = trip
        tripStore.updateTrip(updatedTrip)
        updateTripWithCurrentState()
    }
    
    /// Removes flights at specified indices
    /// - Parameter indexSet: The indices of flights to remove
    func removeFlight(at indexSet: IndexSet) {
        flights.remove(atOffsets: indexSet)
        updateTripWithCurrentState()
    }
    
    /// Removes hotels at specified indices
    /// - Parameter indexSet: The indices of hotels to remove
    func removeHotel(at indexSet: IndexSet) {
        hotels.remove(atOffsets: indexSet)
        updateTripWithCurrentState()
    }
    
    /// Removes activities at specified indices
    /// - Parameter indexSet: The indices of activities to remove
    func removeActivity(at indexSet: IndexSet) {
        activities.remove(atOffsets: indexSet)
        updateTripWithCurrentState()
    }
    
    /// Updates the trip with current state after a debounce period
    func updateTripWithCurrentState() {
        updateTask?.cancel()
        
        updateTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second debounce
            await updateTripWithAPI()
        }
    }
    
    /// Deletes the trip both remotely and locally
    /// - Returns: Boolean indicating successful deletion
    @MainActor
    func deleteTrip() async -> Bool {
        isLoading = true
        
        do {
            try await apiService.deleteTrip(trip.id)
            tripStore.deleteTrip(trip.id)
            isLoading = false
            return true
        } catch {
            // Fallback to local deletion on API failure
            tripStore.deleteTrip(trip.id)
            errorMessage = "Trip deleted locally only due to API error"
            showError = true
            isLoading = false
            return true
        }
    }
}
