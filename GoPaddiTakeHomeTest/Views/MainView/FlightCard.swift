//
//  FlightCard.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct FlightCard: View {
    let flight: Flight
    
    var body: some View {
        VStack(spacing: 0) {
            // Content
            VStack(spacing: 16) {
                // Airline Info
                HStack(spacing: 8) {
                    // Placeholder for airline logo
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
                
                // Action buttons
                HStack {
                    Button("Flight details") {
                        // Handle flight details
                    }
                    .buttonStyle(.plain)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    
                    Button("Price details") {
                        // Handle price details
                    }
                    .buttonStyle(.plain)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    
                    Button("Edit details") {
                        // Handle edit details
                    }
                    .buttonStyle(.plain)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("₦\(flight.price, specifier: "%.2f")")
                        .font(.headline)
                }
                .padding(.top, 8)
                .padding(.bottom, 4)
            }
            .padding()
            .background(Color.white)
            
            // Remove button
            Button {
                // Handle remove
            } label: {
                Text("Remove")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .background(Color.red.opacity(0.1))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

#Preview("Flight Card") {
    FlightCard(flight: Flight(
        id: "1",
        airline: "American Airlines",
        flightNumber: "AA-829",
        departureTime: Date(),
        arrivalTime: Date().addingTimeInterval(6300), // 1h 45m
        origin: "LOS",
        destination: "SIN",
        price: 123450.00
    ))
    .padding()
}
