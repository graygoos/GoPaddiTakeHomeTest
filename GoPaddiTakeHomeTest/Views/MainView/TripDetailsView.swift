//
//  TripDetailsView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct TripDetailsView: View {
    @StateObject private var viewModel: TripDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    @State private var showDeleteAlert = false
    @State private var showCollaborationAlert = false
    @State private var showAddFlight = false
    @State private var showAddHotel = false
    @State private var showAddActivity = false
    
    init(trip: Trip) {
        _viewModel = StateObject(wrappedValue: TripDetailsViewModel(trip: trip))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Image
                if let location = viewModel.trip.location {
                    Image(location.name)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipped()
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Trip Dates Row
                    if let endDate = viewModel.trip.endDate {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .foregroundStyle(.secondary)
                            Text(viewModel.trip.date.formatted(date: .long, time: .omitted))
                            Image(systemName: "arrow.right")
                                .foregroundStyle(.secondary)
                            Text(endDate.formatted(date: .long, time: .omitted))
                        }
                        .font(.system(size: 15))
                    }
                    
                    // Trip Name
                    Text(viewModel.trip.name)
                        .font(.system(size: 24, weight: .bold))
                    
                    // Location and Travel Style
                    if let location = viewModel.trip.location {
                        Text("\(location.name), \(location.country) \(location.flag) | \(viewModel.trip.travelStyle.rawValue) Trip")
                            .font(.system(size: 15))
                            .foregroundStyle(.secondary)
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
                            .foregroundStyle(.blue)
                            .cornerRadius(8)
                        }
                        
                        // Share Trip Button
                        ShareLink(
                            item: "Check out my trip to \(viewModel.trip.location?.name ?? "")",
                            subject: Text("Trip Details"),
                            message: Text("I'm planning a trip to \(viewModel.trip.location?.name ?? "") from \(viewModel.trip.date.formatted(date: .abbreviated, time: .omitted)) to \(viewModel.trip.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "")")
                        ) {
                            HStack {
                                Image(systemName: "arrowshape.turn.up.forward")
                                Text("Share Trip")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.blue.opacity(0.1))
                            .foregroundStyle(.blue)
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
                                .foregroundStyle(.primary)
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
                            .foregroundStyle(.white)
                        Text("Build, personalize, and optimize your itineraries with our trip planner.")
                            .font(.system(size: 15))
                            .foregroundStyle(.white.opacity(0.8))
                        Button {
                            showAddActivity = true
                        } label: {
                            Text("Add Activities")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .foregroundStyle(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "0D1139"))
                    .cornerRadius(12)
                    
                    // Hotels Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hotels")
                            .font(.system(size: 17, weight: .semibold))
                        Text("Build, personalize, and optimize your itineraries with our trip planner.")
                            .font(.system(size: 15))
                            .foregroundStyle(.secondary)
                        Button {
                            showAddHotel = true
                        } label: {
                            Text("Add Hotels")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .foregroundStyle(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Flights Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Flights")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                        Text("Build, personalize, and optimize your itineraries with our trip planner.")
                            .font(.system(size: 15))
                            .foregroundStyle(.white.opacity(0.8))
                        Button {
                            showAddFlight = true
                        } label: {
                            Text("Add Flights")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .foregroundStyle(.blue)
                                .cornerRadius(8)
                        }
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
                            .foregroundStyle(.secondary)
                        
                        // Flights
                        if viewModel.flights.isEmpty {
                            EmptyStateCard(type: .flights) {
                                showAddFlight = true
                            }
                        } else {
                            ForEach(viewModel.flights) { flight in
                                FlightCardSection(flight: flight) {
                                    if let index = viewModel.flights.firstIndex(where: { $0.id == flight.id }) {
                                        viewModel.removeFlight(at: IndexSet(integer: index))
                                    }
                                }
                            }
                        }
                        
                        // Hotels
                        if viewModel.hotels.isEmpty {
                            EmptyStateCard(type: .hotels) {
                                showAddHotel = true
                            }
                        } else {
                            ForEach(viewModel.hotels) { hotel in
                                HotelCardSection(hotel: hotel) {
                                    if let index = viewModel.hotels.firstIndex(where: { $0.id == hotel.id }) {
                                        viewModel.removeHotel(at: IndexSet(integer: index))
                                    }
                                }
                            }
                        }
                        
                        // Activities
                        if viewModel.activities.isEmpty {
                            EmptyStateCard(type: .activities) {
                                showAddActivity = true
                            }
                        } else {
                            ForEach(viewModel.activities) { activity in
                                ActivityCardSection(activity: activity) {
                                    if let index = viewModel.activities.firstIndex(where: { $0.id == activity.id }) {
                                        viewModel.removeActivity(at: IndexSet(integer: index))
                                    }
                                }
                            }
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
                        .foregroundStyle(.white)
                }
            }
        }
        .fullScreenCover(isPresented: $showAddFlight) {
            NavigationStack {
                AddFlightView { flight in
                    viewModel.addFlight(flight)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image(systemName: "airplane")
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showAddHotel) {
            NavigationStack {
                AddHotelView { hotel in
                    viewModel.addHotel(hotel)
                }
                .toolbar {
                    // Hotel icon
                    ToolbarItem(placement: .principal) {
                        Image(systemName: "building.2")
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showAddActivity) {
            NavigationStack {
                AddActivityView { activity in
                    viewModel.addActivity(activity)
                }
                .toolbar {
                    // Activity icon
                    ToolbarItem(placement: .principal) {
                        Image(systemName: "figure.hiking")
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
        .alert("Delete Trip", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    if await viewModel.deleteTrip() {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
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
