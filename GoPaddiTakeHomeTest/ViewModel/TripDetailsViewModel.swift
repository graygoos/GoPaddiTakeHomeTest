//
//  TripDetailsViewModel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

class TripDetailsViewModel: ObservableObject {
    @Published var trip: Trip {
        didSet {
            // Update the trip store whenever the trip changes
            tripStore.updateTrip(trip)
        }
    }
    @Published var flights: [Flight] = [] {
        didSet {
            updateTripWithCurrentState()
        }
    }
    @Published var hotels: [Hotel] = [] {
        didSet {
            updateTripWithCurrentState()
        }
    }
    @Published var activities: [Activity] = [] {
        didSet {
            updateTripWithCurrentState()
        }
    }
    
    private let tripStore = TripStore.shared
    
    init(trip: Trip) {
        self.trip = trip
        self.flights = trip.flights ?? []
        self.hotels = trip.hotels ?? []
        self.activities = trip.activities ?? []
    }
    
    private func updateTripWithCurrentState() {
        var updatedTrip = trip
        updatedTrip.flights = flights
        updatedTrip.hotels = hotels
        updatedTrip.activities = activities
        trip = updatedTrip
    }
    
    func addFlight(_ flight: Flight) {
        flights.append(flight)
    }
    
    func addHotel(_ hotel: Hotel) {
        hotels.append(hotel)
    }
    
    func addActivity(_ activity: Activity) {
        activities.append(activity)
    }
    
    func removeFlight(at indexSet: IndexSet) {
        flights.remove(atOffsets: indexSet)
    }
    
    func removeHotel(at indexSet: IndexSet) {
        hotels.remove(atOffsets: indexSet)
    }
    
    func removeActivity(at indexSet: IndexSet) {
        activities.remove(atOffsets: indexSet)
    }
    
    func deleteTrip() -> Bool {
        tripStore.deleteTrip(trip.id)
        return true
    }
}
