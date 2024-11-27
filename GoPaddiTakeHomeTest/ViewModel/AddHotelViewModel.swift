//
//  AddHotelViewModel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - AddHotelViewModel
/// ViewModel for managing hotel creation and form validation
class AddHotelViewModel: ObservableObject {
    // MARK: - Published Properties
    /// Text for searching hotels
    @Published var searchText = ""
    /// Name of the hotel
    @Published var name = ""
    /// Physical address of the hotel
    @Published var address = ""
    /// Hotel rating (0-5 stars)
    @Published var rating: Double = 0
    /// Number of customer reviews
    @Published var reviews: Int = 0
    /// Type of room (e.g., "Double Suite", "King Room")
    @Published var roomType = ""
    /// Check-in date and time
    @Published var checkIn = Date()
    /// Check-out date and time (defaults to 24 hours after check-in)
    @Published var checkOut = Date().addingTimeInterval(86400)
    /// Price per night
    @Published var price: Double = 0
    
    // MARK: - Form Validation
    /// Checks if all required fields are valid
    var isValid: Bool {
        !name.isEmpty &&
        !address.isEmpty &&
        !roomType.isEmpty &&
        rating > 0 &&
        reviews >= 0 &&
        checkOut > checkIn &&
        price > 0
    }
    
    // MARK: - Hotel Creation
    /// Creates a new Hotel instance if all fields are valid
    /// - Returns: Optional Hotel object, nil if validation fails
    func createHotel() -> Hotel? {
        guard isValid else { return nil }
        return Hotel(
            id: UUID().uuidString,
            name: name,
            address: address,
            rating: rating,
            reviews: reviews,
            roomType: roomType,
            checkIn: checkIn,
            checkOut: checkOut,
            price: price,
            images: []
        )
    }
}
