//
//  AddHotelView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu on
//

import SwiftUI

// MARK: - AddHotelView
/// A view that presents a form for adding a new hotel booking to the travel itinerary.
/// Uses MVVM pattern with `AddHotelViewModel` to manage the form state.
struct AddHotelView: View {
    /// Environment variable to dismiss the view
    @Environment(\.dismiss) private var dismiss
    
    /// View model that manages the form state and business logic
    @StateObject private var viewModel = AddHotelViewModel()
    
    /// Closure called when a new hotel booking is successfully created
    /// - Parameter hotel: The newly created Hotel instance
    let onAdd: (Hotel) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar for filtering hotels (if applicable)
                SearchBar(text: $viewModel.searchText)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                
                // Main form containing hotel details
                Form {
                    // Basic hotel information section
                    Section("Hotel Details") {
                        TextField("Hotel Name", text: $viewModel.name)
                        TextField("Address", text: $viewModel.address)
                        TextField("Room Type", text: $viewModel.roomType)
                    }
                    
                    // Rating and reviews section
                    Section("Rating") {
                        // Interactive star rating system (1-5 stars)
                        HStack {
                            Text("Rating")
                            Spacer()
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: index <= Int(viewModel.rating) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .onTapGesture {
                                        viewModel.rating = Double(index)
                                    }
                            }
                        }
                        TextField("Number of Reviews", value: $viewModel.reviews, format: .number)
                            .keyboardType(.numberPad)
                    }
                    
                    // Booking dates section
                    Section("Dates") {
                        DatePicker("Check-in", selection: $viewModel.checkIn, displayedComponents: .date)
                        DatePicker("Check-out", selection: $viewModel.checkOut, displayedComponents: .date)
                    }
                    
                    // Pricing section (in Nigerian Naira)
                    Section("Price") {
                        TextField("Price", value: $viewModel.price, format: .currency(code: "NGN"))
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Add Hotel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel button to dismiss the view
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                // Save button to create the hotel booking
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let hotel = viewModel.createHotel() {
                            onAdd(hotel)
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
#Preview("AddHotelView - Empty") {
    AddHotelView { hotel in
        print("Hotel added: \(hotel)")
    }
}

#Preview("AddHotelView - Filled") {
    let filledViewModel = AddHotelViewModel()
    filledViewModel.name = "Riviera Resort, Lekki"
    filledViewModel.address = "18, Kenneth Agbakuru Street, Off Access Bank Admiralty Way, Lekki Phase1"
    filledViewModel.roomType = "King size room"
    filledViewModel.rating = 4.5
    filledViewModel.reviews = 436
    filledViewModel.price = 123450.00
    
    return AddHotelView { hotel in
        print("Hotel added: \(hotel)")
    }
    .environmentObject(filledViewModel)
}
