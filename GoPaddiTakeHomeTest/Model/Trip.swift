//
//  Trip.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - Models
struct Trip: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    var destination: String
    var date: Date
    var endDate: Date?
    var details: String
    var price: Double
    var images: [String]
    var location: Location?
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Implement Equatable (required for Hashable)
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        lhs.id == rhs.id
    }
}

struct TripDate: Equatable {
    var startDate: Date?
    var endDate: Date?
}

struct Location: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let country: String
    let flag: String
    let subtitle: String?
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Implement Equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - View Models
class TripViewModel: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService()
    
    func createTrip(_ trip: Trip) async throws {
        await MainActor.run {
            isLoading = true
        }
        
        do {
            let newTrip = try await apiService.createTrip(trip)
            await MainActor.run {
                self.trips.append(newTrip)
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func fetchTrips() async {
        await MainActor.run {
            isLoading = true
        }
        
        do {
            let fetchedTrips = try await apiService.fetchTrips()
            await MainActor.run {
                self.trips = fetchedTrips
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}

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
    
    // Properties to pass data between views
    var currentTripName: String = ""
    var currentTripStyle: TravelStyle = .solo
    var currentTripDescription: String = ""
    
    var canCreateTrip: Bool {
        selectedLocation != nil && tripDates.startDate != nil && tripDates.endDate != nil
    }
    
    func createDetailedTrip(name: String, travelStyle: TravelStyle, description: String) {
        currentTripName = name
        currentTripStyle = travelStyle
        currentTripDescription = description
        
        if let location = selectedLocation,
           let startDate = tripDates.startDate,
           let endDate = tripDates.endDate {
            let newTrip = Trip(
                id: UUID().uuidString,
                name: name,
                destination: "\(location.name), \(location.country)",
                date: startDate,
                endDate: endDate,  // Include end date
                details: description,
                price: 0.0,
                images: [],
                location: location
            )
            
            trips.insert(newTrip, at: 0)
            resetFormData()
            showTripDetail = true
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
        // For now, we'll keep the sample trips and add new ones to them
        if trips.isEmpty {
            trips = []
        }
    }
}
