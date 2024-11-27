//
//  TripCardView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A view that displays a trip card with an image, details, and action button
/// Used in trip listing screens to show trip previews
struct TripCardView: View {
    /// The trip data to display
    let trip: Trip
    /// Callback executed when the view button is tapped
    let onViewTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let location = trip.location {
                // Location image header
                Image(location.name)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                
                // Trip details section
                VStack(alignment: .leading, spacing: 8) {
                    Text(trip.name)
                        .font(.headline)
                    
                    // Date and duration information
                    HStack {
                        Text(trip.date.formatted(date: .abbreviated, time: .omitted))
                        Spacer()
                        if let endDate = trip.endDate {
                            let days = Calendar.current.dateComponents([.day], from: trip.date, to: endDate).day ?? 0
                            Text("\(days) Days")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    // View details button
                    Button(action: onViewTapped) {
                        Text("View")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4, y: 2)
        .padding(.horizontal)
    }
}

#Preview("TripCardView - Light Mode") {
    VStack {
        TripCardView(
            trip: Trip(
                id: "1",
                name: "Bahamas Family Trip",
                destination: "Nassau, Bahamas",
                date: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()),
                details: "A wonderful family vacation in the Bahamas with beach activities and water sports.",
                price: 2450.00,
                images: [],
                location: Location(
                    id: "1",
                    name: "Nassau",
                    country: "Bahamas",
                    flag: "🇧🇸",
                    subtitle: "Paradise Island"
                ), travelStyle: .couple
            )
        ) {
            print("View tapped")
        }
        
        TripCardView(
            trip: Trip(
                id: "2",
                name: "Dubai Adventure",
                destination: "Dubai, UAE",
                date: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
                details: "Luxury resort stay in Dubai with desert safari and city tours.",
                price: 3850.00,
                images: [],
                location: Location(
                    id: "2",
                    name: "Dubai",
                    country: "United Arab Emirates",
                    flag: "🇦🇪",
                    subtitle: "Dubai International"
                ), travelStyle: .group
            )
        ) {
            print("View tapped")
        }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
