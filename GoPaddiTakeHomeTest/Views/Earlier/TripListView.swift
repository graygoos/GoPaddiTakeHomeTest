//
//  TripListView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct TripListView: View {
    @StateObject private var viewModel = TripViewModel()
    @State private var showingCreateTrip = false
    @StateObject private var planningViewModel = TripPlanningViewModel() // Add this
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.trips) { trip in
                        TripCardView(trip: trip)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .background(AppColors.background)
            .navigationTitle("Plan a Trip")
            .toolbar {
                Button(action: { showingCreateTrip = true }) {
                    Image(systemName: "plus")
                        .foregroundColor(AppColors.appBlue)
                }
            }
            .sheet(isPresented: $showingCreateTrip) {
                CreateTripView(viewModel: planningViewModel) // Use planningViewModel here
            }
        }
        .task {
            await viewModel.fetchTrips()
        }
    }
}

#Preview {
    TripListView()
}
