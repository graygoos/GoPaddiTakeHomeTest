//
//  CalendarMonth.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct CalendarMonth: View {
    let month: Date
    @Binding var tripDates: TripDate
    let isSelectingEndDate: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(month, format: .dateTime.month(.wide).year())
                .font(.headline)
            
            let calendar = Calendar.current
            let weeks = calendar.weeks(for: month)
            
            VStack(spacing: 8) {
                WeekdayHeader()
                
                ForEach(weeks, id: \.self) { week in
                    HStack {
                        ForEach(week, id: \.self) { date in
                            if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                                DayCell(
                                    date: date,
                                    tripDates: $tripDates,
                                    isSelectingEndDate: isSelectingEndDate
                                )
                            } else {
                                Text("")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview("CalendarMonth") {
    VStack {
        CalendarMonth(
            month: Date(),
            tripDates: .constant(TripDate(
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())
            )),
            isSelectingEndDate: false
        )
        
        CalendarMonth(
            month: Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date(),
            tripDates: .constant(TripDate()),
            isSelectingEndDate: false
        )
    }
    .padding()
}


// MARK: - Calendar Helpers
extension Calendar {
    func weeks(for month: Date) -> [[Date]] {
        guard let monthInterval = self.dateInterval(of: .month, for: month) else { return [] }
        let firstWeek = self.dateInterval(of: .weekOfMonth, for: monthInterval.start)!.start
        
        var weeks: [[Date]] = []
        var week: [Date] = []
        var date = firstWeek
        
        while date < monthInterval.end {
            week.append(date)
            
            if week.count == 7 {
                weeks.append(week)
                week = []
            }
            
            date = self.date(byAdding: .day, value: 1, to: date)!
        }
        
        return weeks
    }
}
