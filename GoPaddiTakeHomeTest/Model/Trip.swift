//
//  Trip.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - Models
struct Trip: Codable, Identifiable {
    let id: String
    var name: String
    var destination: String
    var date: Date
    var details: String
    var price: Double
    var images: [String]
    var location: Location?
}

struct TripDate: Equatable {
    var startDate: Date?
    var endDate: Date?
}

struct Location: Codable, Identifiable {
    let id: String  // Add this
    let name: String
    let country: String
    let flag: String
    let subtitle: String? // For additional location info like "Doha" in your design
    
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
    @Published var showTripDetail = false
    @Published var trips: [Trip] = [] // Add this property
    
    var canCreateTrip: Bool {
        selectedLocation != nil && tripDates.startDate != nil && tripDates.endDate != nil
    }
    
    func createDetailedTrip(name: String, travelStyle: TravelStyle, description: String) {
        // Create trip and navigate to detail view
        showTripDetail = true
    }
    
    // Optional: Add a method to fetch trips if needed
    func fetchTrips() {
        // Example implementation
        trips = Trip.sampleTrips
    }
}
