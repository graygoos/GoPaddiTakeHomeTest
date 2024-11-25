//
//  Location.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import Foundation

struct Location: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let country: String
    let flag: String
    let subtitle: String?
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Implement Equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
