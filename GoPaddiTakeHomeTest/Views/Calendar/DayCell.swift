//
//  DayCell.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct DayCell: View {
    let date: Date
    @Binding var tripDates: TripDate
    let isSelectingEndDate: Bool
    
    private var isSelected: Bool {
        if isSelectingEndDate {
            return tripDates.endDate?.isSameDay(as: date) ?? false
        } else {
            return tripDates.startDate?.isSameDay(as: date) ?? false
        }
    }
    
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
    
    private func backgroundFor(date: Date) -> Color {
        if isSelected {
            return .appBlue
        } else if isInRange {
            return .appBlue.opacity(0.2)
        }
        return .clear
    }
    
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
            .previewDisplayName("Current Day")
            
            // Selected start date
            DayCell(
                date: Date(),
                tripDates: .constant(TripDate(
                    startDate: Date(),
                    endDate: nil
                )),
                isSelectingEndDate: false
            )
            .previewDisplayName("Selected Start Date")
            
            // Selected end date
            DayCell(
                date: Date(),
                tripDates: .constant(TripDate(
                    startDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()),
                    endDate: Date()
                )),
                isSelectingEndDate: true
            )
            .previewDisplayName("Selected End Date")
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
            .previewDisplayName("In Range")
            
            // Past day
            DayCell(
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                tripDates: .constant(TripDate()),
                isSelectingEndDate: false
            )
            .previewDisplayName("Past Day")
            
            // Future day
            DayCell(
                date: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
                tripDates: .constant(TripDate()),
                isSelectingEndDate: false
            )
            .previewDisplayName("Future Day")
        }
    }
    .padding()
    .previewLayout(.sizeThatFits)
}

// Dark mode preview
#Preview("DayCell - Dark Mode") {
    HStack(spacing: 20) {
        // Selected start date
        DayCell(
            date: Date(),
            tripDates: .constant(TripDate(
                startDate: Date(),
                endDate: nil
            )),
            isSelectingEndDate: false
        )
        
        // Day in range
        DayCell(
            date: Date(),
            tripDates: .constant(TripDate(
                startDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
                endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())
            )),
            isSelectingEndDate: false
        )
        
        // Regular future day
        DayCell(
            date: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
            tripDates: .constant(TripDate()),
            isSelectingEndDate: false
        )
    }
    .padding()
    .previewLayout(.sizeThatFits)
    .preferredColorScheme(.dark)
}

// Different sizes preview
#Preview("DayCell - Sizes") {
    HStack(spacing: 20) {
        DayCell(
            date: Date(),
            tripDates: .constant(TripDate(
                startDate: Date(),
                endDate: nil
            )),
            isSelectingEndDate: false
        )
        .frame(width: 30)
        
        DayCell(
            date: Date(),
            tripDates: .constant(TripDate(
                startDate: Date(),
                endDate: nil
            )),
            isSelectingEndDate: false
        )
        .frame(width: 40)
        
        DayCell(
            date: Date(),
            tripDates: .constant(TripDate(
                startDate: Date(),
                endDate: nil
            )),
            isSelectingEndDate: false
        )
        .frame(width: 50)
    }
    .padding()
    .previewLayout(.sizeThatFits)
}

extension Date {
    var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
}
