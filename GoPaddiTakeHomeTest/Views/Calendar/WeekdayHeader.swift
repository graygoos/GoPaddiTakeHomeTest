//
//  WeekdayHeader.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct WeekdayHeader: View {
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
