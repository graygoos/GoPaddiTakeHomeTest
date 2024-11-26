//
//  CreateTripView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct CreateTripView: View {
    @ObservedObject var viewModel: TripPlanningViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var tripName = ""
    @State private var selectedTravelStyle: TravelStyle?
    @State private var tripDescription = ""
    @State private var navigateToDetails = false
    
    var isFormValid: Bool {
        !tripName.isEmpty && selectedTravelStyle != nil && !tripDescription.isEmpty
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Custom Header
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
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Create a Trip")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Let's Go! Build Your Next Adventure")
                                .foregroundColor(.secondary)
                        }
                        
                        // Trip Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Trip Name")
                                .fontWeight(.medium)
                            TextField("Enter the trip name", text: $tripName)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        // Travel Style
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
                        
                        // Trip Description
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
                
                // Bottom Button
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
        .presentationDetents([.height(UIScreen.main.bounds.height * 0.75)])
    }
}

enum TravelStyle: String, Codable, CaseIterable, Identifiable {
    case solo = "solo"       // Make sure to use lowercase
    case couple = "couple"
    case family = "family"
    case group = "group"
    
    var id: String { rawValue }
    
    // Add custom decoder to handle case-insensitive strings
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self).lowercased()
        
        if let style = TravelStyle(rawValue: rawString) {
            self = style
        } else {
            // Default to solo if unknown value
            self = .solo
        }
    }
}

#Preview("CreateTripView - Light") {
    CreateTripView(viewModel: TripPlanningViewModel())
}

#Preview("CreateTripView - Dark") {
    CreateTripView(viewModel: TripPlanningViewModel())
        .preferredColorScheme(.dark)
}
