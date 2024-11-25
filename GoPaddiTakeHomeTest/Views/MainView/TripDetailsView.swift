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
                // Header Image
                if let location = trip.location {
                    Image(location.name)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipped()
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Trip Dates Row
                    if let endDate = trip.endDate {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .foregroundColor(.secondary)
                            Text(trip.date.formatted(date: .long, time: .omitted))
                            Image(systemName: "arrow.right")
                                .foregroundColor(.secondary)
                            Text(endDate.formatted(date: .long, time: .omitted))
                        }
                        .font(.system(size: 15))
                    }
                    
                    // Trip Name
                    Text(trip.name)
                        .font(.system(size: 24, weight: .bold))
                    
                    // Location and Travel Style
                    if let location = trip.location {
                        Text("\(location.name), \(location.country) \(location.flag) | \(trip.travelStyle.rawValue) Trip")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    
                    // Action Buttons Row
                    HStack(spacing: 12) {
                        // Trip Collaboration Button
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
                        
                        // Share Trip Button
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
                        
                        // More Options Menu
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
                    
                    // Activities Section
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
                    .background(Color(red: 0.06, green: 0.09, blue: 0.23))
                    .cornerRadius(12)
                    
                    // Hotels Section
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
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Flights Section
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
                    
                    // Trip Itineraries Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Trip Itineraries")
                            .font(.headline)
                        Text("Your Trip itineraries are placed here")
                            .foregroundColor(.secondary)
                        
                        // Empty State Cards
                        VStack(spacing: 16) {
                            EmptyStateCard(type: .flights)
                            EmptyStateCard(type: .hotels)
                            EmptyStateCard(type: .activities)
                        }
                    }
                    .padding(.top, 24)
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
        .alert("Delete Trip", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // Handle delete action
            }
        } message: {
            Text("Are you sure you want to delete this trip? This action cannot be undone.")
        }
        .alert("Trip Collaboration", isPresented: $showCollaborationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Trip collaboration feature coming soon!")
        }
    }
}

#Preview("TripDetailsView") {
    NavigationStack {
        TripDetailsView(
            trip: Trip(
                id: "1",
                name: "Bahamas Family Trip",
                destination: "Nassau, Bahamas",
                date: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
                details: "Going on my annual leave holiday with my family",
                price: 0.0,
                images: [],
                location: Location(
                    id: "1",
                    name: "Nassau",
                    country: "Bahamas",
                    flag: "🇧🇸",
                    subtitle: "Paradise Island"
                ),
                travelStyle: .family
            )
        )
    }
}
