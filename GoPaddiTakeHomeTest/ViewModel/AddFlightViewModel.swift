//
//  AddFlightViewModel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// View model for managing flight creation form state and validation
class AddFlightViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// Search text for filtering flights
    @Published var searchText = ""
    /// Name of the airline
    @Published var airline = ""
    /// Flight identifier code
    @Published var flightNumber = ""
    /// Departure airport
    @Published var origin = ""
    /// Arrival airport
    @Published var destination = ""
    /// Departure date and time
    @Published var departureTime = Date()
    /// Arrival date and time (defaults to 1 hour after departure)
    @Published var arrivalTime = Date().addingTimeInterval(3600)
    /// Cost of the flight
    @Published var price: Double = 0
    
    /// Validates that all required fields are properly filled
    /// and arrival time is after departure time
    var isValid: Bool {
        !airline.isEmpty &&
        !flightNumber.isEmpty &&
        !origin.isEmpty &&
        !destination.isEmpty &&
        arrivalTime > departureTime &&
        price > 0
    }
    
    /// Creates a Flight object from the current form state
    /// - Returns: Flight object if validation passes, nil otherwise
    func createFlight() -> Flight? {
        guard isValid else { return nil }
        return Flight(
            id: UUID().uuidString,
            airline: airline,
            flightNumber: flightNumber,
            departureTime: departureTime,
            arrivalTime: arrivalTime,
            origin: origin,
            destination: destination,
            price: price
        )
    }
}
