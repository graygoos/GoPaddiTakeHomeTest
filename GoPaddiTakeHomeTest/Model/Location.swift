//
//  Location.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import Foundation

/// Represents a travel destination or location
struct Location: Codable, Identifiable, Hashable {
    /// Unique identifier for the location
    let id: String
    /// Name of the city or place
    let name: String
    /// Country where the location is situated
    let country: String
    /// Unicode flag emoji for the country
    let flag: String
    /// Optional additional description (e.g., airport name)
    let subtitle: String?
    
    /// Implements Hashable protocol for collection operations
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// Implements equality comparison based on location ID
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
