//
//  TripViewModel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

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
