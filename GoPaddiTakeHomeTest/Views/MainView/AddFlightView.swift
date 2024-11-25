//
//  AddFlightView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu on 25/11/2024.
//

import SwiftUI

struct AddFlightView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddFlightViewModel()
    let onAdd: (Flight) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $viewModel.searchText)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                
                // Flight Form
                Form {
                    Section("Flight Details") {
                        TextField("Airline", text: $viewModel.airline)
                        TextField("Flight Number", text: $viewModel.flightNumber)
                    }
                    
                    Section("Route") {
                        TextField("Origin Airport", text: $viewModel.origin)
                        TextField("Destination Airport", text: $viewModel.destination)
                    }
                    
                    Section("Schedule") {
                        DatePicker("Departure Time", selection: $viewModel.departureTime)
                        DatePicker("Arrival Time", selection: $viewModel.arrivalTime)
                    }
                    
                    Section("Price") {
                        TextField("Price", value: $viewModel.price, format: .currency(code: "NGN"))
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Add Flight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let flight = viewModel.createFlight() {
                            onAdd(flight)
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

#Preview {
    AddFlightView()
}
