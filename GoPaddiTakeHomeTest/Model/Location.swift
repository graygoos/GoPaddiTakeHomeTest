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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
