//
//  Trip.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// Represents a complete travel itinerary
struct Trip: Codable, Identifiable, Hashable {
    /// Unique identifier for the trip
    let id: String
    /// Name/title of the trip
    var name: String
    /// Destination city/location
    var destination: String
    /// Start date of the trip
    var date: Date
    /// Optional end date of the trip
    var endDate: Date?
    /// Detailed description of the trip
    var details: String
    /// Total cost of the trip in local currency
    var price: Double
    /// Collection of trip-related image URLs
    var images: [String]
    /// Associated location details
    var location: Location?
    /// Style of travel (solo, couple, family, etc.)
    var travelStyle: TravelStyle
    /// Collection of booked flights
    var flights: [Flight]?
    /// Collection of hotel bookings
    var hotels: [Hotel]?
    /// Collection of planned activities
    var activities: [Activity]?
    
    /// Defines keys for encoding and decoding Trip objects
    private enum CodingKeys: String, CodingKey {
        case id, name, destination, date, endDate, details, price,
             images, location, travelStyle, flights, hotels, activities
    }
    
    /// Implements Hashable protocol for collection operations
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// Implements equality comparison based on trip ID
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        lhs.id == rhs.id
    }
}

/// Helper struct for managing trip dates
struct TripDate: Equatable {
    /// Start date of the trip
    var startDate: Date?
    /// End date of the trip
    var endDate: Date?
}
