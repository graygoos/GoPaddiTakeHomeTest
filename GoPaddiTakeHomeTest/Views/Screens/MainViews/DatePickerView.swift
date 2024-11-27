//
//  DatePickerView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct DatePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var tripDates: TripDate
    let isSelectingEndDate: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom navigation header
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
            
            ScrollView {
                VStack(spacing: 32) {
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
            
            // Bottom date selection area
            VStack(spacing: 16) {
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
