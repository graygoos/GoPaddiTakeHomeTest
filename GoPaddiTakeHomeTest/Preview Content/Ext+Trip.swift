//
//  Ext+Trip.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - Sample Data

extension Trip {
    static let sampleTrips = [
        Trip(
            id: "1",
            name: "Bahamas Family Trip",
            destination: "Nassau, Bahamas",
            date: Date().addingTimeInterval(86400 * 30), // 30 days from now
            endDate: Date().addingTimeInterval(86400 * 37), // 37 days from now
            details: "A wonderful family vacation in the Bahamas with beach activities and water sports.",
            price: 2450.00,
            images: [
                "https://example.com/bahamas1.jpg",
                "https://example.com/bahamas2.jpg"
            ],
            location: Location(
                id: "1",
                name: "Nassau",
                country: "Bahamas",
                flag: "🇧🇸",
                subtitle: nil
            ),
            travelStyle: .family
        ),
        Trip(
            id: "2",
            name: "Dubai Resort Visit",
            destination: "Dubai, UAE",
            date: Date().addingTimeInterval(86400 * 60), // 60 days from now
            endDate: Date().addingTimeInterval(86400 * 67), // 67 days from now
            details: "Luxury resort stay in Dubai with desert safari and city tours.",
            price: 3850.00,
            images: [
                "https://example.com/dubai1.jpg",
                "https://example.com/dubai2.jpg"
            ],
            location: Location(
                id: "2",
                name: "Dubai",
                country: "United Arab Emirates",
                flag: "🇦🇪",
                subtitle: nil
            ),
            travelStyle: .couple
        )
    ]
}

