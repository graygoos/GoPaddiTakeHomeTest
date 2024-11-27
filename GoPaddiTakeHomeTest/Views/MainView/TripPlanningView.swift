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
                        // Header with hotel image
                        ZStack(alignment: .top) {
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
                            .frame(height: UIScreen.main.bounds.height * 0.75)
                            
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
                            
                            if viewModel.trips.isEmpty && !viewModel.isLoading {
                                Text("No trips planned yet")
                                    .foregroundColor(.secondary)
                                    .padding(.vertical)
                            } else {
                                ForEach(viewModel.trips) { trip in
                                    TripCardView(trip: trip) {
                                        selectedTrip = trip
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                    }
                }
                .coordinateSpace(name: "scroll")
                
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
                            Spacer()
                                .frame(height: UIScreen.main.bounds.height * 0.42)
                            
                            TripPlannerOverlay(viewModel: viewModel)
                                .padding(.horizontal)
                            
                            Spacer()
                        }
                    }
                    .transition(.move(edge: .top))
                }
                
                // Loading Overlay
                if viewModel.isLoading {
                    LoadingOverlay()
                }
                
                // Error Banner
                if viewModel.showError {
                    ErrorBanner(message: viewModel.errorMessage ?? "An error occurred") {
                        viewModel.showError = false
                        viewModel.errorMessage = nil
                    }
                }
            }
            .task {
                await viewModel.fetchTrips()
            }
            .navigationTitle("Plan a Trip")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedTrip) { trip in
                TripDetailsView(trip: trip)
            }
            .navigationDestination(item: $viewModel.newlyCreatedTrip) { trip in
                TripDetailsView(trip: trip)
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
