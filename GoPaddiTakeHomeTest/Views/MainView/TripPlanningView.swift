//
//  TripPlanningView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct TripPlanningView: View {
    @StateObject private var viewModel = TripPlanningViewModel()
    @State private var selectedTrip: Trip?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 0) {
                        // Header with hotel image and text overlay
                        ZStack(alignment: .top) {
                            // Background image
                            GeometryReader { proxy in
                                let minY = proxy.frame(in: .named("scroll")).minY
                                let height = max(0, proxy.size.height + (minY > 0 ? minY : 0))
                                
                                Image("flat-hotel-building")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: proxy.size.width, height: height)
                                    .offset(y: minY > 0 ? -minY : 0)
                                    .clipped()
                            }
                            .frame(height: UIScreen.main.bounds.height * 0.75) // 75% of screen height
                            
                            // Header text
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Plan Your Dream Trip in Minutes")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("Build, personalize, and optimize your itineraries with our trip planner. Perfect for getaways, remote workcations, and any spontaneous escapes.")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }
                        
                        // Your Trips section
                        VStack(alignment: .leading, spacing: 24) {
                            Text("Your Trips")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            if viewModel.trips.isEmpty {
                                Text("No trips planned yet")
                                    .foregroundColor(.secondary)
                                    .padding(.vertical)
                            } else {
                                ForEach(viewModel.trips) { trip in
                                    NavigationLink(destination: TripDetailsView(trip: trip)) {
                                        TripCardView(trip: trip) {
                                            // This closure handles the View button tap
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                    }
                }
                .coordinateSpace(name: "scroll")
                
                // Overlay trip planner
                if viewModel.showingPlannerOverlay {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                viewModel.showingPlannerOverlay = false
                            }
                        }
                    
                    GeometryReader { geometry in
                        VStack {
                            let topPadding = geometry.safeAreaInsets.top + 44 // Navigation bar height
                            let overlayPosition = (UIScreen.main.bounds.height * 0.42) // Position at 35% from top
                            
                            Spacer()
                                .frame(height: overlayPosition)
                            
                            TripPlannerOverlay(viewModel: viewModel)
                                .padding(.horizontal)
                            
                            Spacer()
                        }
                    }
                    .transition(.move(edge: .top))
                }
            }
            .task {
                viewModel.fetchTrips() // Fetch trips when view appears
            }
            .navigationTitle("Plan a Trip")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $viewModel.showTripDetail) {
                if let location = viewModel.selectedLocation {
                    // Create a Trip instance for the new trip
                    let newTrip = Trip(
                        id: UUID().uuidString,
                        name: viewModel.currentTripName,
                        destination: "\(location.name), \(location.country)",
                        date: viewModel.tripDates.startDate ?? Date(),
                        endDate: viewModel.tripDates.endDate,
                        details: viewModel.currentTripDescription,
                        price: 0.0,
                        images: [],
                        location: location
                    )
                    TripDetailsView(trip: newTrip)
                }
            }
            .toolbar {
                Button {
                    withAnimation {
                        viewModel.showingPlannerOverlay = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.appBlue)
                }
            }
            .sheet(isPresented: $viewModel.showCreateTrip) {
                CreateTripView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    TripPlanningView()
}
