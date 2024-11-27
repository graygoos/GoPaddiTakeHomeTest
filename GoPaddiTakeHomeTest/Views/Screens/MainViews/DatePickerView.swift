//
//  DatePickerView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// View for selecting start and end dates for a trip
struct DatePickerView: View {
    /// Environment variable to dismiss the view
    @Environment(\.dismiss) private var dismiss
    /// Binding to hold the selected trip dates
    @Binding var tripDates: TripDate
    /// Flag to determine if selecting end date or start date
    let isSelectingEndDate: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation header with close button and title
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .padding()
                }
                
                Text("Date")
                    .font(.headline)
                
                Spacer()
            }
            .padding(.top, getSafeAreaTop())
            .background(Color(UIColor.systemBackground))
            
            // Scrollable calendar months
            ScrollView {
                VStack(spacing: 32) {
                    // Display 12 months starting from current date
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
            
            // Date selection summary and confirmation button
            VStack(spacing: 16) {
                // Start and end date display
                HStack {
                    VStack(alignment: .leading) {
                        Text("Start Date")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(tripDates.startDate?.formatted(date: .abbreviated, time: .omitted) ?? "Select date")
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("End Date")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(tripDates.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "Select date")
                    }
                }
                
                // Confirmation button
                Button("Choose Date") {
                    dismiss()
                }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
        }
        .background(Color(UIColor.systemBackground))
        .ignoresSafeArea()
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
