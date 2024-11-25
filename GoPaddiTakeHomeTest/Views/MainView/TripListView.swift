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
    @StateObject private var planningViewModel = TripPlanningViewModel()
    @State private var selectedTrip: Trip?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
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
            await viewModel.fetchTrips()
        }
    }
}

#Preview {
    TripListView()
}
