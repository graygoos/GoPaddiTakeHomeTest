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
    
    init(trip: Trip) {
        self.trip = trip
        self.flights = trip.flights ?? []
        self.hotels = trip.hotels ?? []
        self.activities = trip.activities ?? []
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
}
