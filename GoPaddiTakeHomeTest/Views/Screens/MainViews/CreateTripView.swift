//
//  CreateTripView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// View for creating a new trip with basic details like name, style, and description
struct CreateTripView: View {
    /// View model containing trip planning logic and state
    @ObservedObject var viewModel: TripPlanningViewModel
    /// Environment variable to dismiss the view
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State Properties
    /// Name of the trip being created
    @State private var tripName = ""
    /// Selected travel style for the trip
    @State private var selectedTravelStyle: TravelStyle?
    /// Description of the trip
    @State private var tripDescription = ""
    /// Flag to control navigation to trip details
    @State private var navigateToDetails = false
    
    /// Validates if all required fields are filled
    var isFormValid: Bool {
        !tripName.isEmpty && selectedTravelStyle != nil && !tripDescription.isEmpty
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Custom header with logo and close button
                HStack {
                    Image("palm-tree")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.appBlue)
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.appBlue)
                    }
                }
                .padding()
                
                // Main form content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Create a Trip")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Let's Go! Build Your Next Adventure")
                                .foregroundColor(.secondary)
                        }
                        
                        // Trip name input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Trip Name")
                                .fontWeight(.medium)
                            TextField("Enter the trip name", text: $tripName)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        // Travel style selector
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Travel Style")
                                .fontWeight(.medium)
                            Menu {
                                ForEach(TravelStyle.allCases) { style in
                                    Button {
                                        selectedTravelStyle = style
                                    } label: {
                                        Text(style.rawValue)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedTravelStyle?.rawValue ?? "Select your travel style")
                                        .foregroundColor(selectedTravelStyle == nil ? .secondary : .primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                            }
                        }
                        
                        // Trip description input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Trip Description")
                                .fontWeight(.medium)
                            TextEditor(text: $tripDescription)
                                .frame(height: 100)
                                .padding(4)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                
                // Create trip button
                Button {
                    if isFormValid {
                        Task {
                            viewModel.createDetailedTrip(
                                name: tripName,
                                travelStyle: selectedTravelStyle ?? .solo,
                                description: tripDescription
                            )
                            dismiss()
                        }
                    }
                } label: {
                    Text("Next")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.blue : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!isFormValid)
                .padding()
            }
            
            // Loading and error states
            if viewModel.isLoading {
                LoadingOverlay()
            }
            
            if viewModel.showError {
                ErrorBanner(message: viewModel.errorMessage ?? "An error occurred") {
                    viewModel.showError = false
                    viewModel.errorMessage = nil
                }
            }
        }
        .presentationDetents([.height(UIScreen.main.bounds.height * 0.75)])
    }
}

/// Represents different styles of travel that can be selected for a trip
enum TravelStyle: String, Codable, CaseIterable, Identifiable {
    /// Single traveler journey
    case solo = "solo"
    /// Trip planned for two people
    case couple = "couple"
    /// Family vacation style
    case family = "family"
    /// Group travel arrangement
    case group = "group"
    
    /// Conform to Identifiable protocol using rawValue as id
    var id: String { rawValue }
    
    /// Custom decoder implementation to handle case-insensitive string values
    /// - Parameter decoder: The decoder to read data from
    /// - Throws: DecodingError if unable to decode the travel style
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self).lowercased()
        
        if let style = TravelStyle(rawValue: rawString) {
            self = style
        } else {
            // Fallback to solo travel style if unknown value received
            self = .solo
        }
    }
}

#Preview("CreateTripView - Light") {
    CreateTripView(viewModel: TripPlanningViewModel())
}
