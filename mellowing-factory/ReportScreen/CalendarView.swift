//
//  CalendarView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/22.
//

import SwiftUI

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let interval: DateInterval
    let content: (Date) -> DateView
    
    init(interval: DateInterval,
         @ViewBuilder content: @escaping (Date) -> DateView) {
        self.interval = interval
        self.content = content
    }
    
    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        VStack {
            ForEach(months, id: \.self) { month in
                MonthView(month: month, content: self.content)
            }
        }
    }
}

struct CalendarYearView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    var columns: [GridItem]
    let interval: DateInterval
    let content: (Date) -> DateView
    
    init(columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
        interval: DateInterval,
         @ViewBuilder content: @escaping (Date) -> DateView) {
        self.columns = columns
        self.interval = interval
        self.content = content
    }
    
    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: Size.w(8)) {
            ForEach(months, id: \.self) { month in
                self.content(month)
            }
        }
    }
}

struct MonthView<DateView>: View where DateView: View {
    @EnvironmentObject var vc: ContentViewController
    @Environment(\.calendar) var calendar
    
    let month: Date
    let content: (Date) -> DateView
    
    init(
        month: Date,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.month = month
        self.content = content
    }
    
    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
        else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }
    
    var body: some View {
        VStack(spacing: Size.h(7)) {
            Spacer()
            ForEach(weeks, id: \.self) { week in
                CalendarWeekView(week: week, content: self.content)
                if week != weeks.last {
                    Divider()
                }
            }
        }.padding(.horizontal, Size.w(32))
    }
}

struct CalendarWeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let week: Date
    let content: (Date) -> DateView
    
    init(week: Date, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.week = week
        self.content = content
    }
    
    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
        else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        HStack(spacing: Size.w(5)) {
            ForEach(days, id: \.self) { date in
                HStack {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date)
                    } else {
                        self.content(date).hidden()
                    }
                }
            }
        }
    }
}
