//
//  TripDetailsView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct TripDetailsView: View {
    let trip: Trip  // Change to accept Trip instead of individual properties
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Image with Gradient Overlay
                if let location = trip.location {
                    ZStack(alignment: .bottom) {
                        Image(location.name)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(trip.name)
                                .font(.title)
                                .fontWeight(.bold)
                            Text("\(location.name), \(location.country)")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.black.opacity(0.7), .clear],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .foregroundColor(.white)
                    }
                }
                
                VStack(spacing: 24) {
                    // Dates
                    if let endDate = trip.endDate {
                        DetailRow(
                            icon: "calendar",
                            iconColor: .blue,
                            title: "Dates",
                            detail: formatDateRange(start: trip.date, end: endDate)
                        )
                    }
                    
                    // Location
                    if let location = trip.location {
                        DetailRow(
                            icon: "location.fill",
                            iconColor: .blue,
                            title: "Location",
                            detail: "\(location.name), \(location.country) \(location.flag)"
                        )
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        Text(trip.details)
                            .foregroundColor(.secondary)
                    }
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        ActionButton(
                            title: "Add Activities",
                            subtitle: "Build, personalize, and optimize your itineraries with our trip planner",
                            action: { print("Add Activities") }
                        )
                        
                        ActionButton(
                            title: "Add Hotels",
                            subtitle: "Find and book the perfect place to stay",
                            action: { print("Add Hotels") }
                        )
                        
                        ActionButton(
                            title: "Add Flights",
                            subtitle: "Search and compare flight options",
                            action: { print("Add Flights") }
                        )
                    }
                }
                .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Trip Collaboration", action: {})
                    Button("Share Trip", action: {})
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func formatDateRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
}

#Preview("TripDetailsView - Light Mode") {
    NavigationStack {
        TripDetailsView(
            trip: Trip(
                id: "1",
                name: "Annual leave",
                destination: "Laghouat, Algeria",
                date: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
                details: "Going on my annual leave holiday with my family",
                price: 0.0,
                images: [],
                location: Location(
                    id: "1",
                    name: "Laghouat",
                    country: "Algeria",
                    flag: "🇩🇿",
                    subtitle: "Laghouat"
                )
            )
        )
    }
}
