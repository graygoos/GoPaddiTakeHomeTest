//
//  TripStore.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - TripStore
/// Manages persistent storage of trips using UserDefaults
class TripStore: ObservableObject {
    // MARK: - Static Properties
    /// Shared instance for singleton access
    static let shared = TripStore()
    
    // MARK: - Published Properties
    /// Collection of stored trips
    @Published var trips: [Trip] = []
    
    // MARK: - Private Properties
    /// UserDefaults key for storing trips
    private let tripsKey = "SavedTrips"
    
    // MARK: - Initialization
    /// Initializes the store and loads saved trips
    init() {
        loadTrips()
    }
    
    // MARK: - Public Methods
    /// Loads trips from UserDefaults
    func loadTrips() {
        if let savedTrips = UserDefaults.standard.data(forKey: tripsKey),
           let decodedTrips = try? JSONDecoder().decode([Trip].self, from: savedTrips) {
            self.trips = decodedTrips
        }
    }
    
    /// Saves trips to UserDefaults
    func saveTrips() {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: tripsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    /// Updates an existing trip or adds a new one
    /// - Parameter updatedTrip: The trip to update or add
    func updateTrip(_ updatedTrip: Trip) {
        if let index = trips.firstIndex(where: { $0.id == updatedTrip.id }) {
            trips[index] = updatedTrip
        } else {
            trips.insert(updatedTrip, at: 0)
        }
        saveTrips()
    }
    
    /// Deletes a trip by ID
    /// - Parameter tripId: The ID of the trip to delete
    func deleteTrip(_ tripId: String) {
        trips.removeAll { $0.id == tripId }
        saveTrips()
    }
}
