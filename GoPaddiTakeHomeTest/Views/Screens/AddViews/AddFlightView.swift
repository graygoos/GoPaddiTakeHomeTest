//
//  AddFlightView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - AddFlightView
/// A view that presents a form for adding a new flight booking to the travel itinerary.
/// Uses MVVM pattern with `AddFlightViewModel` to manage the form state.
struct AddFlightView: View {
    /// Environment variable to dismiss the view
    @Environment(\.dismiss) private var dismiss
    
    /// View model that manages the form state and business logic
    @StateObject private var viewModel = AddFlightViewModel()
    
    /// Closure called when a new flight is successfully created
    /// - Parameter flight: The newly created Flight instance
    let onAdd: (Flight) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar for filtering flights (if applicable)
                SearchBar(text: $viewModel.searchText)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                
                // Main form containing flight details
                Form {
                    // Basic flight information section
                    Section("Flight Details") {
                        TextField("Airline", text: $viewModel.airline)
                        TextField("Flight Number", text: $viewModel.flightNumber)
                    }
                    
                    // Flight route information
                    Section("Route") {
                        TextField("Origin Airport", text: $viewModel.origin)
                        TextField("Destination Airport", text: $viewModel.destination)
                    }
                    
                    // Flight timing section
                    Section("Schedule") {
                        DatePicker("Departure Time", selection: $viewModel.departureTime)
                        DatePicker("Arrival Time", selection: $viewModel.arrivalTime)
                    }
                    
                    // Pricing section (in Nigerian Naira)
                    Section("Price") {
                        TextField("Price", value: $viewModel.price, format: .currency(code: "NGN"))
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Add Flight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel button to dismiss the view
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                // Save button to create the flight
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let flight = viewModel.createFlight() {
                            onAdd(flight)
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValid)  // Disabled when form is invalid
                }
            }
        }
    }
}

// Preview
#Preview("AddFlightView - Empty") {
    AddFlightView { flight in
        print("Flight added: \(flight)")
    }
}

#Preview("AddFlightView - Filled") {
    let filledViewModel = AddFlightViewModel()
    filledViewModel.airline = "American Airlines"
    filledViewModel.flightNumber = "AA-829"
    filledViewModel.origin = "LOS"
    filledViewModel.destination = "SIN"
    filledViewModel.price = 123450.00
    
    return AddFlightView { flight in
        print("Flight added: \(flight)")
    }
    .environmentObject(filledViewModel)
}
