//
//  FlightCard.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct FlightCard: View {
    let flight: Flight
    var onRemove: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Content
            VStack(spacing: 16) {
                // Airline Info
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 32, height: 32)
                    
                    VStack(alignment: .leading) {
                        Text(flight.airline)
                            .font(.headline)
                        Text(flight.flightNumber)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Flight Route
                HStack {
                    // Departure
                    VStack(alignment: .leading) {
                        Text(flight.departureTime.formatted(date: .omitted, time: .shortened))
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(flight.departureTime.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(flight.origin)
                            .font(.headline)
                    }
                    
                    // Flight duration
                    VStack {
                        Text(flight.duration)
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Arrival
                    VStack(alignment: .trailing) {
                        Text(flight.arrivalTime.formatted(date: .omitted, time: .shortened))
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(flight.arrivalTime.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(flight.destination)
                            .font(.headline)
                    }
                }
                
                // Action buttons and price
                HStack {
                    ActionLink(title: "Flight details")
                    ActionLink(title: "Price details")
                    ActionLink(title: "Edit details")
                    
                    Spacer()
                    
                    Text("₦\(flight.price, specifier: "%.2f")")
                        .font(.headline)
                }
            }
            .padding()
            .background(Color.white)
            
            // Remove button
            Button(action: onRemove) {
                Text("Remove")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.1))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

#Preview("FlightCard - Various States") {
    ScrollView {
        VStack(spacing: 20) {
            // Regular flight
            FlightCard(
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
            FlightCard(
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
}
