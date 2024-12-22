//
//  MonthlyReportView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/06.
//

import SwiftUI

struct MonthlyReportView: View {
    @EnvironmentObject var weekStore: WeekStore
    @Environment(\.calendar) var calendar
    @Binding var timeFrame: StatisticsTimeFrame
//    @Binding var openMonthly: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: Size.statusBarHeight)
                ScrollView(showsIndicators: false) {
                    ScrollViewReader { reader in
                        CalendarYearView(columns: [GridItem(.flexible())], interval: calendar.dateInterval(of: .year, for: weekStore.selectedDate)!) { date in
                            MonthlyCalendarView(timeFrame: $timeFrame, date: date)
                                .id(date.toString(dateFormat: "MMM"))
                        }
                        .onAppear {
                            withAnimation {
                                reader.scrollTo(weekStore.selectedDate.toString(dateFormat: "MMM"), anchor: .top)
                            }
                        }
                        Spacer().frame(height: 100)
                    }
                }
            }
            
            VStack {
                let days: [String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
                HStack(alignment: .center) {
                    ForEach(days, id: \.self) { day in
                        Text(LocalizedStringKey(day))
                            .foregroundColor(.gray300)
                            .font(semiBold14Font)
                            .frame(maxWidth: .infinity)
                    }
                }.padding(.horizontal, Size.w(32))
                 .padding(.bottom, Size.h(15))
                 .padding(.top, Size.h(15))
                 .background(Blur(style: .systemUltraThinMaterialLight, intensity: 0.3).ignoresSafeArea())
                Spacer()
            }
            
        }.navigationView(title: LocalizedStringKey(weekStore.selectedDate.toString(dateFormat: "YYY")), backButtonHidden: true)
            .navigationBarItems(trailing: Button(action: {
                withAnimation {
                    weekStore.selectedDate = Date()
                    timeFrame = .weekly
                }
            }) {
                Text("TODAY")
                    .foregroundColor(.gray800)
                    .font(medium16Font)
            })
            .navigationBarItems(leading: Button(action: {
                DispatchQueue.main.async {
                    withAnimation {
//                        openMonthly = false
                        timeFrame = .yearly
                    }
                }
            }) {
                Image("ic-calendar-yearly")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Size.w(44), height: Size.w(44))
            })
    }
}

struct MonthlyCalendarView: View {
    @EnvironmentObject var weekStore: WeekStore
    @Environment(\.calendar) var calendar

    @Binding var timeFrame: StatisticsTimeFrame
    
    @State var statistics: StatisticsResponse?
    @State var isLoading = false
    @State var isDummyData = true
    
    @State var openWeekly = false
    
    var date: Date
    let radarSize = Size.w(36)
    private var month: DateInterval { calendar.dateInterval(of: .month, for: date)! }
    private let apiNodeServer = ApiNodeServer()
    
    var body: some View {
        VStack(spacing: Size.h(15)) {
//            NavigationLink(isActive: $openWeekly, destination: {
//                WeeklyReportView(openWeekly: $openWeekly)
//            }) {
//                EmptyView()
//            }.isDetailLink(false)
            
            HStack {
                Text(date.toString(dateFormat: "MMM"))
                    .font(semiBold20Font)
                    .foregroundColor(.gray800)
                Spacer()
                NavigationLink(destination: {
                    ReportDetailsView(timeFrame: .monthly, statistics: statistics ?? testerMonthly, year: date)
                }) {
                    HStack {
                        Text("REPORT")
                        Image(systemName: "arrow.right")
                    }.font(semiBold13Font)
                     .foregroundColor(.gray500)
                }
            }.padding(.horizontal, Size.w(32))
            
            ZStack {
                CalendarView(interval: month) { date in
                    ZStack {
                        let dayNumber = Int(date.toString(dateFormat: "dd"))! - 1
                        if statistics?.radarValues.count ?? 0 > dayNumber {
                            ZStack {
                                if statistics?.radarValues[dayNumber] != [0,0,0,0,0] {
                                    Button(action: {
                                        withAnimation {
                                            weekStore.selectedDate = date
//                                            openWeekly = true
                                            timeFrame = .weekly
                                        }
                                    }) {
                                        ZStack {
                                            RadarChartPath(data: [1, 1, 1, 1, 1])
                                                .stroke(Color.gray100, lineWidth: 1)
                                            RadarChartPath(data: statistics?.radarValues[dayNumber].map { Double($0)/100 } ?? [])
                                                .fill(statistics?.sleepQuality[dayNumber].color() ?? Color.clear)
                                        }
                                    }
                                } else {
                                    RadarChartPath(data: [1, 1, 1, 1, 1])
                                        .stroke(Color.gray100, style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                                }
                                
                            }
                        } else {
                            RadarChartPath(data: [1, 1, 1, 1, 1])
                                .stroke(Color.gray100, style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                        }
                        if dayNumber < statistics?.radarValues.count ?? 99 {
                            Text(date.toString(dateFormat: "dd"))
                                .font(bold14Font)
                                .foregroundColor(statistics?.radarValues[dayNumber] != [0,0,0,0,0] ? .gray600 : .gray100)
                        } else {
                            Text(date.toString(dateFormat: "dd"))
                                .font(bold14Font)
                                .foregroundColor(.gray100)
                        }
                    }.frame(width: radarSize, height: radarSize)
                        .padding(.horizontal, Size.w(2))
                }
            }.redacted(reason: isLoading ? .placeholder : [])
        }
        .padding(.top, Size.h(25))
        .padding(.bottom, Size.h(18))
        .disabled(isDummyData)
        .opacity(isDummyData ? 0.4 : 1)
        .onAppear {
            if Defaults.presentationMode {
                self.statistics = presentStatistics(timeFrame: .monthly, date: date)
                isDummyData = false
            } else {
                if isDummyData {
                    isLoading = true
                    loadStatistics() {_ in }
                }
            }
        }
    }
    
    func loadStatistics(completion: @escaping (Bool) -> Void) {
        guard !date.isInFuture else {
            self.statistics = nil
            self.isLoading = false
            return
        }
        
        let convertedDate = date.plusOffset()
        let statisticsRealm = StatisticsResponse.loadFromRealm(date: convertedDate, timeFrame: .monthly)
        if let statisticsRealm {
            DispatchQueue.main.async {
                isLoading = false
                self.statistics = statisticsRealm
                isDummyData = false
                completion(true)
            }
        } else {
            apiNodeServer.queryStatistics(journalDate: date, timeFrame: .monthly) { (result) in
                DispatchQueue.main.async {
                    withAnimation {
                        self.isLoading = false
                        switch result {
                        case .success(let statistics):
                            self.statistics = statistics
                            saveRealm(date: convertedDate, statistics: statistics)
                            isDummyData = false
                            completion(true)
                        case .failure:
                            isDummyData = true
                            print("has error on Monthly Report")
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    
    private func saveRealm(date: Date, statistics: StatisticsResponse) {
        ///    MonthlyReportView: shifted one day later to save. Somehow if it is 31st its already define it as different month
        let modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let isCurrentPeriod: ComparisonResult = Calendar.current.compare(date, to: modifiedDate, toGranularity: .month)
        if isCurrentPeriod != .orderedSame {
            StatisticsResponse.saveToRealm(statistics: statistics, timeframe: StatisticsTimeFrame.monthly.rawValue, requestedDate: date)
        }
    }
}
