//
//  TripListView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// Main view displaying a list of trips and navigation to trip creation
struct TripListView: View {
    // MARK: - Properties
    
    /// View model managing trip data and operations
    @StateObject private var viewModel = TripViewModel()
    
    /// Controls display of trip creation sheet
    @State private var showingCreateTrip = false
    
    /// View model for trip planning functionality
    @StateObject private var planningViewModel = TripPlanningViewModel()
    
    /// Currently selected trip for navigation
    @State private var selectedTrip: Trip?
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    // List of existing trips
                    ForEach(viewModel.trips) { trip in
                        NavigationLink(destination: TripDetailsView(trip: trip)) {
                            TripCardView(trip: trip) {
                                selectedTrip = trip
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top)
            }
            .background(AppColors.background)
            .navigationTitle("Plan a Trip")
            .toolbar {
                // Create new trip button
                Button(action: { showingCreateTrip = true }) {
                    Image(systemName: "plus")
                        .foregroundColor(AppColors.appBlue)
                }
            }
            .sheet(isPresented: $showingCreateTrip) {
                CreateTripView(viewModel: planningViewModel)
            }
            .navigationDestination(item: $selectedTrip) { trip in
                TripDetailsView(trip: trip)
            }
        }
        .task {
            // Load trips when view appears
            await viewModel.fetchTrips()
        }
    }
}

#Preview {
    TripListView()
}
