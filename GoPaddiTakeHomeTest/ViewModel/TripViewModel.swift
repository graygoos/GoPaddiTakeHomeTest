//
//  TripViewModel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - TripViewModel
/// ViewModel for managing the main trips list and trip creation
class TripViewModel: ObservableObject {
    // MARK: - Published Properties
    /// List of all trips
    @Published var trips: [Trip] = []
    /// Loading state indicator
    @Published var isLoading = false
    /// Error message for displaying to user
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    /// Service for API interactions
    private let apiService = APIService()
    
    // MARK: - Public Methods
    /// Creates a new trip
    /// - Parameter trip: The trip to create
    /// - Throws: Any error that occurs during API interaction
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
    
    /// Fetches all trips from the API
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
