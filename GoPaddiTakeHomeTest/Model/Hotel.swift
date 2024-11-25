//
//  Hotel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import Foundation

struct Hotel: Identifiable, Codable {
    let id: String
    var name: String
    var address: String
    var rating: Double
    var reviews: Int
    var roomType: String
    var checkIn: Date
    var checkOut: Date
    var price: Double
    var images: [String]
}
