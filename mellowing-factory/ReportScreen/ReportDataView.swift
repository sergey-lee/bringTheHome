//
//  ReportDataView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/15.
//

import SwiftUI

struct ReportDataView: View {
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var weekStore: WeekStore
    @Environment(\.calendar) var calendar
    
    @Binding var openDaily: Bool
    @Binding var scrolled: Bool
    
    @State var index: Int = 0
    @State var days: [Date] = [Date(), Date(), Date(), Date(), Date(), Date(), Date()]
    
//    var statistics: StatisticsResponse?
    
    var body: some View {
        ZStack(alignment: .top) {
            BarChartGrid(scrolled: $scrolled,
                         yAxis: scrolled ? yAxisPlaceholder
                         : weekStore.statistics?.sleepStages.getStatisticsYAxisSteps() ?? yAxisPlaceholderS)
//            .padding(.top, Size.w(78))
            
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .bottom, spacing: Size.w(9.8)) {
                    ForEach(0..<7, id:\.self) { index in
                        ZStack(alignment: .top) {
//                            VStack(spacing: 3) {
//                                Text(LocalizedStringKey(weekDays[index]))
//                                    .tracking(-1)
//                                    .lineLimit(1)
//                                if let statistics {
//                                    /// check duration of this (index) day
//                                    if statistics.radarValues[index][4] != 0 {
//                                        Button(action: {
//                                            self.index = index
//                                            openDetails()
//                                        }) {
//                                            ZStack {
//                                                RadarChartPath(data: [1, 1, 1, 1, 1])
//                                                    .stroke(Color.gray100, lineWidth: 1)
//                                                Text(days[index].toString(dateFormat: "dd"))
//                                                    .foregroundColor(.gray600)
//                                                    .font(bold14Font)
//                                                RadarChartPath(data: statistics.radarValues[index].map { Double($0)/100 })
//                                                    .fill(statistics.sleepQuality[index].color())
//                                            }.frame(width: Size.w(36), height: Size.w(36))
//                                        }
//                                    } else {
//                                        ZStack {
//                                            Text(days[index].toString(dateFormat: "dd"))
//                                                .foregroundColor(.gray100)
//                                                .font(bold14Font)
//                                            RadarChartPath(data: [1, 1, 1, 1, 1])
//                                                .stroke(Color.gray100, style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
//                                                .frame(width: Size.w(36), height: Size.w(36))
//                                        }
//                                    }
//                                } else {
//                                    ZStack {
//                                        Text(days[index].toString(dateFormat: "dd"))
//                                            .foregroundColor(.gray100)
//                                            .font(bold14Font)
//                                        RadarChartPath(data: [1, 1, 1, 1, 1])
//                                            .stroke(Color.gray100, style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
//                                            .frame(width: Size.w(36), height: Size.w(36))
//                                    }
//                                }
//                            }
                            
                            if let statistics = weekStore.statistics {
                                let stages = statistics.sleepStages.sleepStages[index]
                                VStack(spacing: 0) {
                                    Spacer()
                                    if !stages.isEmpty {
                                        Button(action: {
                                            self.index = index
                                            openDetails()
                                        }) {
                                            BarView(scrolled: $scrolled, statistics: statistics, index: index)
                                        }.frame(height: Size.w(170))
                                    }
                                }.frame(width: Size.w(36), height: Size.w(182), alignment: .top)
//                                    .padding(.top, Size.w(78))
                                    .disabled(stages.isEmpty || stages == [0])
                            }
                        }
                    }
                }.foregroundColor(.gray300)
                    .font(semiBold14Font)
                    .padding(.horizontal, Size.w(32))
            }
            
            NavigationLink(isActive: $openDaily, destination: {
                if let statistics = weekStore.statistics {
                    DailyDetails(isDailyOpened: $openDaily, selectedDate: days[index], averageRadar: statistics.lastWeekData())
                }
            }) { EmptyView() }.isDetailLink(false)
        }
//        .padding(.top, Size.w(14))
        .padding(.bottom, Size.w(5))
        .frame(width: UIScreen.main.bounds.width)
        .onAppear {
//            getWeek(date: vc.journalDate)
        }
    }
    
    func getWeek(date: Date) {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date)
        else { return }
        self.days = calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    func openDetails() {
        self.openDaily = true
    }
}
