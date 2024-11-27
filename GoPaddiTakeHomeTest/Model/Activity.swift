//
//  Activity.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu on 25/11/2024.
//

import Foundation

/// Represents a tourist or travel activity that can be added to a trip
struct Activity: Identifiable, Codable {
    /// Unique identifier for the activity
    let id: String
    /// Name of the activity
    var name: String
    /// Detailed description of what the activity entails
    var description: String
    /// Physical location where the activity takes place
    var location: String
    /// User rating score out of 5.0
    var rating: Double
    /// Number of user reviews
    var reviews: Int
    /// Length of time the activity takes (e.g., "2 hours")
    var duration: String
    /// Scheduled date and time for the activity
    var timeSlot: Date
    /// Which day of the trip this activity is scheduled for
    var day: String
    /// Cost of the activity in the local currency
    var price: Double
    /// Collection of image URLs showing the activity
    var images: [String]
}










