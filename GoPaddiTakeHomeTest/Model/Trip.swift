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
                location: location
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
