//
//  TripStore.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

class TripStore: ObservableObject {
    static let shared = TripStore()
    @Published var trips: [Trip] = []
    private let tripsKey = "SavedTrips"
    
    init() {
        loadTrips()
    }
    
    func loadTrips() {
        if let savedTrips = UserDefaults.standard.data(forKey: tripsKey),
           let decodedTrips = try? JSONDecoder().decode([Trip].self, from: savedTrips) {
            self.trips = decodedTrips
        }
    }
    
    func saveTrips() {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: tripsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func updateTrip(_ updatedTrip: Trip) {
        if let index = trips.firstIndex(where: { $0.id == updatedTrip.id }) {
            trips[index] = updatedTrip
        } else {
            trips.insert(updatedTrip, at: 0)
        }
        saveTrips()
    }
    
    func deleteTrip(_ tripId: String) {
        trips.removeAll { $0.id == tripId }
        saveTrips()
    }
}
