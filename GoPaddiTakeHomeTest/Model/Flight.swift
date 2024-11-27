//
//  Flight.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import Foundation

/// Represents a flight booking within a trip
struct Flight: Identifiable, Codable {
    /// Unique identifier for the flight
    let id: String
    /// Name of the airline operating the flight
    var airline: String
    /// Flight identifier code (e.g., "AA123")
    var flightNumber: String
    /// Scheduled departure date and time
    var departureTime: Date
    /// Scheduled arrival date and time
    var arrivalTime: Date
    /// Departure airport code
    var origin: String
    /// Arrival airport code
    var destination: String
    /// Cost of the flight in the local currency
    var price: Double
    
    /// Calculated flight duration in hours and minutes
    var duration: String {
        let difference = Calendar.current.dateComponents([.hour, .minute], from: departureTime, to: arrivalTime)
        return "\(difference.hour ?? 0)h \(difference.minute ?? 0)m"
    }
}
