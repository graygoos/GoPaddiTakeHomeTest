//
//  TripDetailsView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct TripDetailsView: View {
    let trip: Trip
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    @State private var showCollaborationAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Image without text overlay
                if let location = trip.location {
                    Image(location.name)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipped()
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Date with calendar icon
                    if let endDate = trip.endDate {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .foregroundColor(.secondary)
                            Text(trip.date.formatted(date: .abbreviated, time: .omitted))
                                .foregroundColor(.secondary)
                            Image(systemName: "arrow.right")
                                .foregroundColor(.secondary)
                            Text(endDate.formatted(date: .abbreviated, time: .omitted))
                                .foregroundColor(.secondary)
                        }
                        .font(.system(size: 15))
                    }
                    
                    // Trip name
                    Text(trip.name)
                        .font(.system(size: 24, weight: .bold))
                    
                    // Location and travel style
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
                    HStack(spacing: 12) {
                        Button {
                            showCollaborationAlert = true
                        } label: {
                            HStack {
                                Image("handshake")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                Text("Trip Collaboration")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                        }
                        
                        // Using ShareLink for sharing
                        ShareLink(
                            item: "Check out my trip to \(trip.location?.name ?? "")",
                            subject: Text("Trip Details"),
                            message: Text("I'm planning a trip to \(trip.location?.name ?? "") from \(trip.date.formatted(date: .abbreviated, time: .omitted)) to \(trip.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "")")
                        ) {
                            HStack {
                                Image(systemName: "arrowshape.turn.up.forward")
                                Text("Share Trip")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                        }
                        
                        Menu {
                            Button(role: .destructive) {
                                showDeleteAlert = true
                            } label: {
                                Label("Delete Trip", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.primary)
                                .frame(width: 40, height: 40)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // Activities Card - Dark navy background
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Activities")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Build, personalize, and optimize your itineraries with our trip planner.")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.8))
                        Button("Add Activities") {
                            // Handle add activities
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(red: 0.06, green: 0.09, blue: 0.23)) // Dark navy color
                    .cornerRadius(12)
                    
                    // Hotels Card - Very light blue background
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hotels")
                            .font(.system(size: 17, weight: .semibold))
                        Text("Build, personalize, and optimize your itineraries with our trip planner.")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                        Button("Add Hotels") {
                            // Handle add hotels
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1)) // Very light blue background
                    .cornerRadius(12)
                    
                    // Flights Card - Blue background with white button
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Flights")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Build, personalize, and optimize your itineraries with our trip planner.")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.8))
                        Button("Add Flights") {
                            // Handle add flights
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue)
                    .cornerRadius(12)
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
        }
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
