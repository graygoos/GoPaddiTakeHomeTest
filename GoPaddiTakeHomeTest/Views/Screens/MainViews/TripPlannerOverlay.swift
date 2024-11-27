//
//  TripPlannerOverlay.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// An overlay view that provides trip planning functionality including location selection and date picking
struct TripPlannerOverlay: View {
    // MARK: - Properties
    
    /// View model containing trip planning logic and state
    @ObservedObject var viewModel: TripPlanningViewModel
    
    /// Controls the presentation of the trip creation sheet
    @State private var showCreateTripSheet = false
    
    /// Controls the display of validation alert when required fields are missing
    @State private var showAlert = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Location Selection
            
            /// Location picker button that displays either selected city or default prompt
            Button {
                viewModel.showLocationPicker = true
            } label: {
                HStack {
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
            
            // MARK: - Date Selection
            
            HStack(spacing: 16) {
                /// Start date picker button
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
                
                /// End date picker button
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
            
            // MARK: - Create Trip Button
            
            /// Button to initiate trip creation, shows alert if required fields are missing
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
        // MARK: - Container Styling
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 2)
        )
        .padding(.horizontal)
        
        // MARK: - Sheets and Alerts
        
        /// Sheet for trip creation flow
        .sheet(isPresented: $showCreateTripSheet) {
            CreateTripView(viewModel: viewModel)
        }
        
        /// Alert for missing required information
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
