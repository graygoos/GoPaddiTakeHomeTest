//
//  HotelCardSection.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct HotelCardSection: View {
    let hotel: Hotel
    var onRemove: () -> Void
    
    var body: some View {
        CardContainer(type: .hotels) {
            HotelCard(hotel: hotel, onRemove: onRemove)
        }
    }
}

#Preview("HotelCardSection") {
    VStack(spacing: 20) {
        // Luxury hotel
        HotelCardSection(
            hotel: Hotel(
                id: "1",
                name: "Ritz Carlton",
                address: "Fifth Avenue, New York",
                rating: 5.0,
                reviews: 1000,
                roomType: "Double Suite",
                checkIn: Date(),
                checkOut: Date().addingTimeInterval(86400 * 10),
                price: 450000.00,
                images: []
            )
        ) {
            print("Remove tapped")
        }
        
        // Standard hotel
        HotelCardSection(
            hotel: Hotel(
                id: "2",
                name: "Hilton Garden Inn",
                address: "123 Business District",
                rating: 4.0,
                reviews: 500,
                roomType: "King Room",
                checkIn: Date(),
                checkOut: Date().addingTimeInterval(86400 * 3),
                price: 150000.00,
                images: []
            )
        ) {
            print("Remove tapped")
        }
    }
    .padding()
}
