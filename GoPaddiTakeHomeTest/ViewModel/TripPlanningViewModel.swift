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
    
    private let tripStore = TripStore.shared
    
    init() {
        // Initialize with trips from the store
        self.trips = tripStore.trips
    }
    
    var currentTripName: String = ""
    var currentTripStyle: TravelStyle = .solo
    var currentTripDescription: String = ""
    
    var canCreateTrip: Bool {
        selectedLocation != nil && tripDates.startDate != nil && tripDates.endDate != nil
    }
    
    func createDetailedTrip(name: String, travelStyle: TravelStyle, description: String) {
        if let location = selectedLocation,
           let startDate = tripDates.startDate,
           let endDate = tripDates.endDate {
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
            
            tripStore.trips.insert(newTrip, at: 0)
            tripStore.saveTrips()
            
            self.trips = tripStore.trips
            newlyCreatedTrip = newTrip
            showTripDetail = true
            resetFormData()
        }
    }
    
    private func resetFormData() {
        selectedLocation = nil
        tripDates = TripDate()
        currentTripName = ""
        currentTripStyle = .solo
        currentTripDescription = ""
    }
    
    func fetchTrips() {
        tripStore.loadTrips()
        self.trips = tripStore.trips
    }
}
