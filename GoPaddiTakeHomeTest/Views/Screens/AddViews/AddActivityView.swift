//
//  AddActivityView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - AddActivityView
/// A view that presents a form for adding a new activity/attraction to the travel itinerary.
/// Uses MVVM pattern with `AddActivityViewModel` to manage the form state.
struct AddActivityView: View {
    /// Environment variable to dismiss the view
    @Environment(\.dismiss) private var dismiss
    
    /// View model that manages the form state and business logic
    @StateObject private var viewModel = AddActivityViewModel()
    
    /// Closure called when a new activity is successfully created
    /// - Parameter activity: The newly created Activity instance
    let onAdd: (Activity) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar for filtering activities (if applicable)
                SearchBar(text: $viewModel.searchText)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                
                // Main form containing activity details
                Form {
                    // Basic activity information section
                    Section("Activity Details") {
                        TextField("Activity Name", text: $viewModel.name)
                        TextField("Description", text: $viewModel.description, axis: .vertical)
                            .lineLimit(3...6)  // Allows 3-6 lines of text
                        TextField("Location", text: $viewModel.location)
                        TextField("Duration", text: $viewModel.duration)
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
                    
                    // Scheduling information section
                    Section("Schedule") {
                        DatePicker("Time Slot", selection: $viewModel.timeSlot)
                        TextField("Day", text: $viewModel.day)
                    }
                    
                    // Pricing section (in Nigerian Naira)
                    Section("Price") {
                        TextField("Price", value: $viewModel.price, format: .currency(code: "NGN"))
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Add Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel button to dismiss the view
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                // Save button to create the activity
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let activity = viewModel.createActivity() {
                            onAdd(activity)
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
