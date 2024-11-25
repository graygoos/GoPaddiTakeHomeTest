//
//  Trip.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - Models
struct Trip: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    var destination: String
    var date: Date
    var endDate: Date?
    var details: String
    var price: Double
    var images: [String]
    var location: Location?
    var travelStyle: TravelStyle
    var flights: [Flight]?
    var hotels: [Hotel]?
    var activities: [Activity]?
    
    // Custom Coding Keys in case you need them
    private enum CodingKeys: String, CodingKey {
        case id, name, destination, date, endDate, details, price, images, location, travelStyle
    }
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Implement Equatable
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        lhs.id == rhs.id
    }
}

struct TripDate: Equatable {
    var startDate: Date?
    var endDate: Date?
}
