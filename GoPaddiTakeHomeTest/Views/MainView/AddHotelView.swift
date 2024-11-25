//
//  AddHotelView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu on
//

import SwiftUI

struct AddHotelView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddHotelViewModel()
    let onAdd: (Hotel) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $viewModel.searchText)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                
                // Hotel Form
                Form {
                    Section("Hotel Details") {
                        TextField("Hotel Name", text: $viewModel.name)
                        TextField("Address", text: $viewModel.address)
                        TextField("Room Type", text: $viewModel.roomType)
                    }
                    
                    Section("Rating") {
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
                    
                    Section("Dates") {
                        DatePicker("Check-in", selection: $viewModel.checkIn, displayedComponents: .date)
                        DatePicker("Check-out", selection: $viewModel.checkOut, displayedComponents: .date)
                    }
                    
                    Section("Price") {
                        TextField("Price", value: $viewModel.price, format: .currency(code: "NGN"))
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Add Hotel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let hotel = viewModel.createHotel() {
                            onAdd(hotel)
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValid)
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
