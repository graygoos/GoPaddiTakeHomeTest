//
//  TripRowView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - TripRowView
/// A view that represents a single trip in a list or collection.
/// Displays key trip information in a compact format.
struct TripRowView: View {
    /// The trip model containing all the necessary information to display
    let trip: Trip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Trip name as the primary identifier
            Text(trip.name)
                .font(.headline)
            
            // Destination information
            Text(trip.destination)
                .font(.subheadline)
            
            // Trip date in the system's preferred format
            Text(trip.date, style: .date)
                .font(.caption)
            
            // Trip price in USD with appropriate styling
            Text(trip.price, format: .currency(code: "USD"))
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 8)
    }
}

#Preview("TripRowView - List") {
    List {
        TripRowView(trip: Trip.sampleTrips[0])
        
        ForEach(Trip.sampleTrips, id: \.id) { trip in
            TripRowView(trip: trip)
        }
    }
}
