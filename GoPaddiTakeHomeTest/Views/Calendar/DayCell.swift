//
//  DayCell.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A view representing a single day cell in a calendar view
/// Used for selecting trip start and end dates
struct DayCell: View {
   /// The date represented by this cell
   let date: Date
   /// Binding to the selected trip dates
   @Binding var tripDates: TripDate
   /// Whether the user is selecting an end date (true) or start date (false)
   let isSelectingEndDate: Bool
   
   /// Whether this date cell is currently selected
   private var isSelected: Bool {
       if isSelectingEndDate {
           return tripDates.endDate?.isSameDay(as: date) ?? false
       } else {
           return tripDates.startDate?.isSameDay(as: date) ?? false
       }
   }
   
   /// Whether this date falls within the selected date range
   private var isInRange: Bool {
       guard let start = tripDates.startDate,
             let end = tripDates.endDate else { return false }
       return date >= start && date <= end
   }
   
   var body: some View {
       Button {
           if isSelectingEndDate {
               tripDates.endDate = date
           } else {
               tripDates.startDate = date
           }
       } label: {
           Text(date.dayString)
               .frame(maxWidth: .infinity)
               .padding(.vertical, 8)
               .background(backgroundFor(date: date))
               .foregroundColor(foregroundFor(date: date))
               .clipShape(RoundedRectangle(cornerRadius: 6))
       }
   }
   
   /// Determines the background color for a given date
   /// - Parameter date: The date to check
   /// - Returns: The appropriate background color based on selection state
   private func backgroundFor(date: Date) -> Color {
       if isSelected {
           return .appBlue
       } else if isInRange {
           return .appBlue.opacity(0.2)
       }
       return .clear
   }
   
   /// Determines the text color for a given date
   /// - Parameter date: The date to check
   /// - Returns: The appropriate text color based on selection and availability
   private func foregroundFor(date: Date) -> Color {
       if isSelected {
           return .white
       } else if date < Date().startOfDay {
           return .gray
       }
       return .primary
   }
}

#Preview("DayCell States") {
    HStack(spacing: 20) {
        VStack(spacing: 20) {
            // Regular day
            DayCell(
                date: Date(),
                tripDates: .constant(TripDate()),
                isSelectingEndDate: false
            )
            
            // Selected start date
            DayCell(
                date: Date(),
                tripDates: .constant(TripDate(
                    startDate: Date(),
                    endDate: nil
                )),
                isSelectingEndDate: false
            )
            
            // Selected end date
            DayCell(
                date: Date(),
                tripDates: .constant(TripDate(
                    startDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()),
                    endDate: Date()
                )),
                isSelectingEndDate: true
            )
        }
        
        VStack(spacing: 20) {
            // Day in range
            DayCell(
                date: Date(),
                tripDates: .constant(TripDate(
                    startDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
                    endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())
                )),
                isSelectingEndDate: false
            )

            
            // Past day
            DayCell(
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                tripDates: .constant(TripDate()),
                isSelectingEndDate: false
            )
            
            // Future day
            DayCell(
                date: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
                tripDates: .constant(TripDate()),
                isSelectingEndDate: false
            )
        }
    }
    .padding()
}

// MARK: - Date Extensions
extension Date {
    /// Returns the day as a string (e.g. "1", "2", etc)
    var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
    
    /// Returns the start of the current day
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// Checks if two dates fall on the same day
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
}
