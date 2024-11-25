//
//  Flight.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import Foundation

struct Flight: Identifiable, Codable {
    let id: String
    var airline: String
    var flightNumber: String
    var departureTime: Date
    var arrivalTime: Date
    var origin: String
    var destination: String
    var price: Double
    
    var duration: String {
        let difference = Calendar.current.dateComponents([.hour, .minute], from: departureTime, to: arrivalTime)
        return "\(difference.hour ?? 0)h \(difference.minute ?? 0)m"
    }
}
