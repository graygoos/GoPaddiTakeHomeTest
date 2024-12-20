//
//  FlightCard.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A view that displays flight details in a trip itinerary
/// Shows airline information, departure/arrival times, and related actions
struct FlightCard: View {
    /// The flight data to display
    let flight: Flight
    /// Callback executed when the remove action is confirmed
    var onRemove: () -> Void
    /// Controls visibility of the remove confirmation alert
    @State private var showRemoveAlert = false
    
    /// Formats a date into a readable string format (e.g., "Sun, 20 Aug")
    /// - Parameter date: The date to format
    /// - Returns: A formatted string representation of the date
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content section
            VStack(spacing: 16) {
                // Airline and flight number header
                HStack(spacing: 12) {
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
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                // Flight schedule layout
                HStack(alignment: .top) {
                    // Departure information
                    VStack(alignment: .trailing) {
                        Text(flight.departureTime.formatted(date: .omitted, time: .shortened))
                            .font(.system(size: 24, weight: .medium))
                        Text(formatDate(flight.departureTime))
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    // Flight duration and route
                    VStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "airplane.departure")
                            Text(flight.duration)
                            Image(systemName: "airplane.arrival")
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        
                        // Progress indicator
                        Rectangle()
                            .fill(Color.appBlue.opacity(0.2))
                            .frame(height: 2)
                            .overlay(
                                Rectangle()
                                    .fill(Color.appBlue)
                                    .frame(width: 60)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            )
                        
                        // Route details
                        HStack(spacing: 8) {
                            Text(flight.origin)
                            Text("Direct")
                                .foregroundColor(.secondary)
                            Text(flight.destination)
                        }
                        .font(.system(size: 14))
                    }
                    .frame(width: 120)
                    Spacer()
                    
                    // Arrival information
                    VStack(alignment: .leading) {
                        Text(flight.arrivalTime.formatted(date: .omitted, time: .shortened))
                            .font(.system(size: 24, weight: .medium))
                        Text(formatDate(flight.arrivalTime))
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                
                Divider()
                
                // Action links
                HStack {
                    ForEach(["Flight details", "Price details", "Edit details"], id: \.self) { text in
                        Button(action: {}) {
                            Text(text)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.appBlue)
                        }
                        if text != "Edit details" {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                Divider()
                
                // Price display
                HStack {
                    Text("₦\(flight.price, specifier: "%.2f")")
                        .font(.system(size: 16, weight: .medium))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color.white)
            
            // Remove button
            Button {
                showRemoveAlert = true
            } label: {
                HStack(spacing: 8) {
                    Text("Remove")
                        .foregroundColor(.red)
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
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
