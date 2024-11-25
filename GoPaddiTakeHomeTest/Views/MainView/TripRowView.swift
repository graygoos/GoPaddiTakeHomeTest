//
//  TripRowView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct TripRowView: View {
    let trip: Trip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(trip.name)
                .font(.headline)
            Text(trip.destination)
                .font(.subheadline)
            Text(trip.date, style: .date)
                .font(.caption)
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
