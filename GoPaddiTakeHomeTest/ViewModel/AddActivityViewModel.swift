//
//  AddActivityViewModel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// View model for managing activity creation form state and validation
class AddActivityViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// Search text for filtering activities
    @Published var searchText = ""
    /// Name of the activity
    @Published var name = ""
    /// Detailed description of the activity
    @Published var description = ""
    /// Location where activity takes place
    @Published var location = ""
    /// Rating out of 5.0
    @Published var rating: Double = 0
    /// Number of reviews
    @Published var reviews: Int = 0
    /// Duration of the activity
    @Published var duration = ""
    /// Scheduled time for the activity
    @Published var timeSlot = Date()
    /// Day designation in the itinerary
    @Published var day = "Day 1 (Activity 1)"
    /// Cost of the activity
    @Published var price: Double = 0
    
    /// Validates that all required fields are properly filled
    var isValid: Bool {
        !name.isEmpty &&
        !description.isEmpty &&
        !location.isEmpty &&
        !duration.isEmpty &&
        rating > 0 &&
        reviews >= 0 &&
        !day.isEmpty &&
        price > 0
    }
    
    /// Creates an Activity object from the current form state
    /// - Returns: Activity object if validation passes, nil otherwise
    func createActivity() -> Activity? {
        guard isValid else { return nil }
        return Activity(
            id: UUID().uuidString,
            name: name,
            description: description,
            location: location,
            rating: rating,
            reviews: reviews,
            duration: duration,
            timeSlot: timeSlot,
            day: day,
            price: price,
            images: []
        )
    }
}
