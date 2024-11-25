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
    
    private let tripsKey = "SavedTrips"
    
    init() {
        loadTrips()
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
                travelStyle: travelStyle // Add this line
            )
            
            trips.insert(newTrip, at: 0)
            saveTrips()
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
    
    private func saveTrips() {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: tripsKey)
        }
    }
    
    private func loadTrips() {
        if let savedTrips = UserDefaults.standard.data(forKey: tripsKey),
           let decodedTrips = try? JSONDecoder().decode([Trip].self, from: savedTrips) {
            trips = decodedTrips
        }
    }
    
    func fetchTrips() {
        loadTrips()
    }
}
