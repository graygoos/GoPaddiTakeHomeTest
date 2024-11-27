//
//  TripPlannerOverlay.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct TripPlannerOverlay: View {
    @ObservedObject var viewModel: TripPlanningViewModel
    @State private var showCreateTripSheet = false
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Where to?
            Button {
                viewModel.showLocationPicker = true
            } label: {
                HStack {
                    // Use custom location icon from assets
                    Image("location-icon") 
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.blue)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Where to?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(viewModel.selectedLocation?.name ?? "Select City")
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .fullScreenCover(isPresented: $viewModel.showLocationPicker) {
                LocationPickerView(selectedLocation: $viewModel.selectedLocation)
            }
            
            // Date Selection
            HStack(spacing: 16) {
                // Start Date
                Button {
                    viewModel.isSelectingEndDate = false
                    viewModel.showDatePicker = true
                } label: {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundStyle(.blue)
                            .frame(width: 24, height: 24)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Start Date")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(viewModel.tripDates.startDate?.formatted(date: .abbreviated, time: .omitted) ?? "Enter Date")
                                .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // End Date
                Button {
                    viewModel.isSelectingEndDate = true
                    viewModel.showDatePicker = true
                } label: {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundStyle(.blue)
                            .frame(width: 24, height: 24)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("End Date")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(viewModel.tripDates.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "Enter Date")
                                .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .fullScreenCover(isPresented: $viewModel.showDatePicker) {
                DatePickerView(
                    tripDates: $viewModel.tripDates,
                    isSelectingEndDate: viewModel.isSelectingEndDate
                )
            }
            
            // Create Trip Button
            Button {
                if viewModel.canCreateTrip {
                    showCreateTripSheet = true
                } else {
                    showAlert = true
                }
            } label: {
                Text("Create a Trip")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 2)
        )
        .padding(.horizontal)
        .sheet(isPresented: $showCreateTripSheet) {
            CreateTripView(viewModel: viewModel)
        }
        .alert("Missing Information", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please select both location and dates for your trip")
        }
    }
}

#Preview("TripPlannerOverlay") {
    ZStack {
        Color.gray.opacity(0.3)
            .ignoresSafeArea()
        
        TripPlannerOverlay(viewModel: {
            let vm = TripPlanningViewModel()
            vm.selectedLocation = Location(
                id: "",
                name: "",
                country: "Dubai",
                flag: "United Arab Emirates",
                subtitle: "🇦🇪"
            )
            vm.tripDates = TripDate(
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())
            )
            return vm
        }())
    }
}
