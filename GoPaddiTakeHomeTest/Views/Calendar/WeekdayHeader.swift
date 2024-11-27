//
//  WeekdayHeader.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - Weekday Header View
/// A view displaying abbreviated weekday names in a row
struct WeekdayHeader: View {
    /// Array of abbreviated weekday names from the current calendar
    private let weekdays = Calendar.current.shortWeekdaySymbols
    
    var body: some View {
        HStack {
            ForEach(weekdays, id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    WeekdayHeader()
}
