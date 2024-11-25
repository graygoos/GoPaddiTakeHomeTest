//
//  FlightCardSection.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct FlightCardSection: View {
    let flight: Flight
    var onRemove: () -> Void
    
    var body: some View {
        CardContainer(type: .flights) {
            FlightCard(flight: flight, onRemove: onRemove)
        }
    }
}

#Preview("FlightCardSection") {
    VStack(spacing: 20) {
        // Regular flight
        FlightCardSection(
            flight: Flight(
                id: "1",
                airline: "American Airlines",
                flightNumber: "AA-829",
                departureTime: Date(),
                arrivalTime: Date().addingTimeInterval(6300), // 1h 45m
                origin: "LOS",
                destination: "SIN",
                price: 123450.00
            )
        ) {
            print("Remove tapped")
        }
        
        // Long duration flight
        FlightCardSection(
            flight: Flight(
                id: "2",
                airline: "Emirates",
                flightNumber: "EK-801",
                departureTime: Date(),
                arrivalTime: Date().addingTimeInterval(28800), // 8h
                origin: "DXB",
                destination: "JFK",
                price: 245000.00
            )
        ) {
            print("Remove tapped")
        }
    }
    .padding()
}
