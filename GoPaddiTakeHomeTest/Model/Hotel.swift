//
//  Hotel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import Foundation

/// Represents a hotel booking within a trip
struct Hotel: Identifiable, Codable {
    /// Unique identifier for the hotel booking
    let id: String
    /// Name of the hotel
    var name: String
    /// Full address of the hotel
    var address: String
    /// User rating score out of 5.0
    var rating: Double
    /// Number of user reviews
    var reviews: Int
    /// Type of room booked (e.g., "Double Suite")
    var roomType: String
    /// Check-in date and time
    var checkIn: Date
    /// Check-out date and time
    var checkOut: Date
    /// Cost of the stay in the local currency
    var price: Double
    /// Collection of image URLs showing the hotel and rooms
    var images: [String]
}
