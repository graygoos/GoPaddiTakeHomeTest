//
//  TripDetailsView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct TripDetailsView: View {
    let tripName: String
    let travelStyle: TravelStyle
    let description: String
    @ObservedObject var viewModel: TripPlanningViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Destination Image
                ZStack(alignment: .top) {
                    // Placeholder image or actual destination image
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: 200)
                    
                    VStack {
                        Spacer()
                        HStack {
                            VStack(alignment: .leading) {
                                Text(tripName)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                if let location = viewModel.selectedLocation {
                                    Text("\(location.name), \(location.country)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                
                // Trip Details
                VStack(spacing: 24) {
                    // Dates
                    if let startDate = viewModel.tripDates.startDate,
                       let endDate = viewModel.tripDates.endDate {
                        TripDetailRow(
                            icon: "calendar",
                            title: "Dates",
                            detail: "\(startDate.formatted(date: .abbreviated, time: .omitted)) - \(endDate.formatted(date: .abbreviated, time: .omitted))"
                        )
                    }
                    
                    // Travel Style
                    TripDetailRow(
                        icon: "person.2.fill",
                        title: "Travel Style",
                        detail: travelStyle.rawValue
                    )
                    
                    // Location
                    if let location = viewModel.selectedLocation {
                        TripDetailRow(
                            icon: "location.fill",
                            title: "Location",
                            detail: "\(location.name), \(location.country) \(location.flag)"
                        )
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        Text(description)
                            .foregroundColor(.secondary)
                    }
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        ActionButton(
                            title: "Add Activities",
                            subtitle: "Build, personalize, and optimize your itineraries with our trip planner",
                            action: {}
                        )
                        
                        ActionButton(
                            title: "Add Hotels",
                            subtitle: "Find and book the perfect place to stay",
                            action: {}
                        )
                        
                        ActionButton(
                            title: "Add Flights",
                            subtitle: "Search and compare flight options",
                            action: {}
                        )
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Trip Collaboration", action: {})
                    Button("Share Trip", action: {})
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview("TripDetailsView - Full Data") {
    NavigationStack {
        TripDetailsView(
            tripName: "Bahamas Family Trip",
            travelStyle: .family,
            description: "A wonderful family vacation in the Bahamas with beach activities and water sports.",
            viewModel: {
                let vm = TripPlanningViewModel()
                vm.selectedLocation = Location(
                    id: "1",
                    name: "Nassau",
                    country: "Bahamas",
                    flag: "🇧🇸",
                    subtitle: "Paradise Island"
                )
                vm.tripDates = TripDate(
                    startDate: Date(),
                    endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())
                )
                return vm
            }()
        )
    }
}
