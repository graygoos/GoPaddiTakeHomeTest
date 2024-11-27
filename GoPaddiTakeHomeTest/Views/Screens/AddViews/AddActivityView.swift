//
//  AddActivityView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct AddActivityView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddActivityViewModel()
    let onAdd: (Activity) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $viewModel.searchText)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                
                // Activity Form
                Form {
                    Section("Activity Details") {
                        TextField("Activity Name", text: $viewModel.name)
                        TextField("Description", text: $viewModel.description, axis: .vertical)
                            .lineLimit(3...6)
                        TextField("Location", text: $viewModel.location)
                        TextField("Duration", text: $viewModel.duration)
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
                    
                    Section("Schedule") {
                        DatePicker("Time Slot", selection: $viewModel.timeSlot)
                        TextField("Day", text: $viewModel.day)
                    }
                    
                    Section("Price") {
                        TextField("Price", value: $viewModel.price, format: .currency(code: "NGN"))
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Add Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let activity = viewModel.createActivity() {
                            onAdd(activity)
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
#Preview("AddActivityView - Empty") {
    AddActivityView { activity in
        print("Activity added: \(activity)")
    }
}

#Preview("AddActivityView - Filled") {
    let filledViewModel = AddActivityViewModel()
    filledViewModel.name = "The Museum of Modern Art"
    filledViewModel.description = "Works from Van Gogh to Warhol & beyond plus a sculpture garden, 2 cafes & The modern restaurant"
    filledViewModel.location = "Melbourne, Australia"
    filledViewModel.duration = "1 hour"
    filledViewModel.rating = 4.5
    filledViewModel.reviews = 436
    filledViewModel.day = "Day 1 (Activity 1)"
    filledViewModel.price = 123450.00
    
    return AddActivityView { activity in
        print("Activity added: \(activity)")
    }
    .environmentObject(filledViewModel)
}
