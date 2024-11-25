//
//  Activity.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu on 25/11/2024.
//

import Foundation

struct Activity: Identifiable, Codable {
    let id: String
    var name: String
    var description: String
    var location: String
    var rating: Double
    var reviews: Int
    var duration: String
    var timeSlot: Date
    var day: String
    var price: Double
    var images: [String]
}
