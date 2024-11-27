//
//  DatePickerView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A view that displays a calendar interface for selecting trip start and end dates
/// This view presents a scrollable calendar with a custom header and bottom date selection area
struct DatePickerView: View {
    // MARK: - Properties
    
    /// Environment variable to handle view dismissal
    @Environment(\.dismiss) private var dismiss
    
    /// Binding to the selected trip dates, allows two-way data flow with parent view
    @Binding var tripDates: TripDate
    
    /// Flag indicating whether user is selecting end date (true) or start date (false)
    let isSelectingEndDate: Bool
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Header
            
            HStack {
                // Dismiss button
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .padding()
                }
                
                // Title
                Text("Date")
                    .font(.headline)
                
                Spacer()
            }
            .padding(.top, getSafeAreaTop())
            .background(Color(UIColor.systemBackground))
            
            // MARK: - Calendar Scroll View
            
            ScrollView {
                VStack(spacing: 32) {
                    // Generate calendar months for the next year
                    ForEach(0..<12) { month in
                        CalendarMonth(
                            month: Calendar.current.date(
                                byAdding: .month,
                                value: month,
                                to: Date()) ?? Date(),
                            tripDates: $tripDates,
                            isSelectingEndDate: isSelectingEndDate
                        )
                    }
                }
                .padding()
            }
            
            // MARK: - Bottom Date Selection Area
            
            VStack(spacing: 0) {
                // Visual separator between calendar and selection area
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 1)
                
                VStack(spacing: 16) {
                    // MARK: Date Selection Boxes
                    
                    HStack(spacing: 12) {
                        // Start date selection box
                        VStack(spacing: 4) {
                            Text("Start Date")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(tripDates.startDate?.formatted(date: .abbreviated, time: .omitted) ?? "Select date")
                                .font(.subheadline)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity) // Ensures equal width with end date box
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                        
                        // End date selection box
                        VStack(spacing: 4) {
                            Text("End Date")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(tripDates.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "Select date")
                                .font(.subheadline)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity) // Ensures equal width with start date box
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                    
                    // MARK: - Confirmation Button
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Choose Date")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                .padding(16)
                .background(Color(UIColor.systemBackground))
            }
        }
        .background(Color(UIColor.systemBackground))
        .ignoresSafeArea() // Extends view to edges of screen
    }
}

#Preview("DatePickerView") {
    DatePickerView(
        tripDates: .constant(TripDate(
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())
        )),
        isSelectingEndDate: false
    )
}
