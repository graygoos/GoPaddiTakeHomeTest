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
    @State private var showRemoveAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content
            VStack(spacing: 16) {
                // Airline and flight number
                HStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 32, height: 32)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(flight.airline)
                            .font(.system(size: 16, weight: .medium))
                        Text(flight.flightNumber)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Flight times and route
                HStack {
                    // Departure
                    VStack(alignment: .leading) {
                        Text(flight.departureTime.formatted(date: .omitted, time: .shortened))
                            .font(.system(size: 24, weight: .medium))
                        Text(flight.departureTime.formatted(date: .abbreviated, time: .omitted))
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                        Text(flight.origin)
                            .font(.system(size: 16, weight: .medium))
                    }
                    
                    Spacer()
                    
                    // Duration
                    VStack(spacing: 4) {
                        Image(systemName: "airplane")
                            .font(.system(size: 14))
                        Text(flight.duration)
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    Spacer()
                    
                    // Arrival
                    VStack(alignment: .trailing) {
                        Text(flight.arrivalTime.formatted(date: .omitted, time: .shortened))
                            .font(.system(size: 24, weight: .medium))
                        Text(flight.arrivalTime.formatted(date: .abbreviated, time: .omitted))
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                        Text(flight.destination)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                
                // Action links
                HStack {
                    ForEach(["Flight details", "Price details", "Edit details"], id: \.self) { text in
                        Button(action: {}) {
                            Text(text)
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                        }
                        if text != "Edit details" {
                            Spacer()
                        }
                    }
                }
                
                // Price
                HStack {
                    Spacer()
                    Text("₦\(flight.price, specifier: "%.2f")")
                        .font(.system(size: 16, weight: .medium))
                }
            }
            .padding(16)
            .background(Color.white)
            
            // Remove button
            Button {
                showRemoveAlert = true
            } label: {
                HStack {
                    Text("Remove")
                        .foregroundColor(.red)
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.red.opacity(0.1))
            }
        }
        .modifier(RemoveAlertModifier(
            showAlert: $showRemoveAlert,
            title: "Remove Flight",
            message: "Are you sure you want to remove this flight?",
            onConfirm: onRemove
        ))
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
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
