//
//  YearlyView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/06.
//

import SwiftUI

struct YearlyReportView: View {
    @EnvironmentObject var weekStore: WeekStore
    @EnvironmentObject var userManager: UserManager
    @Binding var timeFrame: StatisticsTimeFrame
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                ScrollViewReader { reader in
                    ForEach(getList(), id: \.self) { year in
                        YearlyCalendarView(timeFrame: $timeFrame, year: year)
                            .id(year.toString(dateFormat: "YYY"))
                    }.onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation {
                                reader.scrollTo(weekStore.selectedDate.toString(dateFormat: "YYY"), anchor: .top)
                            }
                        }
                    }
                    Spacer().frame(height: 100)
                }
            }
        }.navigationView(title: LocalizedStringKey(Date().toString(dateFormat: "YYY")), backButtonHidden: true)
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
    }
    
    private func getList() -> [Date] {
        // FIXME: created date -> current date -> plus one year
        var plusYearComponents = DateComponents()
        var plusTwoComponents = DateComponents()
        plusYearComponents.year = 1
        plusTwoComponents.year = 2
        let createdDate = userManager.apiNodeUser.created?.convertToDate() ?? Date()
        let nextYear = Calendar.current.date(byAdding: plusYearComponents, to: createdDate)
        let nextNextYear = Calendar.current.date(byAdding: plusTwoComponents, to: createdDate)
        
        return [createdDate, nextYear!, nextNextYear!]
    }
}

struct YearlyCalendarView: View {
    @EnvironmentObject var weekStore: WeekStore
    @Environment(\.calendar) var calendar
    
    @Binding var timeFrame: StatisticsTimeFrame
    
    @State var statistics: StatisticsResponse?
    @State var isLoading = false
    @State var isDummyData = true
//    @State var openMonthly = false
    
    let apiNodeServer = ApiNodeServer()
    
    let radarSize = Size.w(70)
    var year: Date
    
    var body: some View {
        ZStack {
//            NavigationLink(isActive: $openMonthly, destination: {
//                MonthlyReportView(openMonthly: $openMonthly)
//            }) {
//                EmptyView()
//            }.isDetailLink(false)
            
            VStack {
                HStack {
                    Text(year.toString(dateFormat: "YYY"))
                        .font(semiBold17Font)
                    Spacer()
                    NavigationLink(destination: {
                        ReportDetailsView(timeFrame: .yearly, statistics: statistics ?? testerYearly2023, year: year)
                    }) {
                        HStack {
                            Text("REPORT")
                            Image(systemName: "arrow.right")
                        }.font(semiBold13Font)
                    }
                }
                .foregroundColor(isDummyData ? .gray300 : .gray800)
                .padding(.horizontal, Size.w(32))
                .padding(.bottom, Size.h(20))
                
                CalendarYearView(interval: calendar.dateInterval(of: .year, for: year)!) { date in
                    let monthNumber = Int(date.toString(dateFormat: "MM"))! - 1
                    ZStack {
                        if (statistics?.radarValues[monthNumber].reduce(0, +)) ?? 0 > 0 {
                            Button(action: {
                                DispatchQueue.main.async {
                                    withAnimation {
                                        weekStore.selectedDate = date
                                        timeFrame = .monthly
//                                        openMonthly = true
                                    }
                                }
                            }) {
                                ZStack {
                                    RadarChartPath(data: [1, 1, 1, 1, 1])
                                        .stroke(Color.gray100, lineWidth: 1)
                                        .frame(width: radarSize, height: radarSize)
                                    RadarChartPath(data: statistics?.radarValues[monthNumber].map { Double($0)/100 } ?? [])
                                        .fill(statistics?.sleepQuality[monthNumber].color() ?? Color.clear)
                                        .frame(width:radarSize, height: radarSize)
                                    
                                    Text(date.toString(dateFormat: "MMM"))
                                        .font(bold14Font)
                                        .foregroundColor(.gray600)
                                }
                            }
                        } else {
                            ZStack {
                                RadarChartPath(data: [1, 1, 1, 1, 1])
                                    .stroke(Color.gray100, style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                                    .frame(width: radarSize, height: radarSize)
                                Text(date.toString(dateFormat: "MMM"))
                                    .font(bold16Font)
                                    .foregroundColor(.gray100)
                            }
                        }
                    }
                }
                .padding(.horizontal, Size.w(42))
                .redacted(reason: isLoading ? .placeholder : [])
            }
            
        }
        .padding(.top, Size.h(25))
        .padding(.bottom, Size.h(18))
        .onAppear {
            if Defaults.presentationMode {
                DispatchQueue.main.async {
                    withAnimation {
                        self.statistics =  presentStatistics(timeFrame: .yearly, date: year)
                        isDummyData = false
                    }
                }
            } else {
                if isDummyData {
                    isLoading = true
                    loadStatistics() {_ in}
                }
            }
        }
        //         .onReceive(vc.$refreshReportScreen) {_ in
        //             withAnimation {
        //                 if vc.journalDate.endOfWeek != Date().plusOffset().endOfWeek {
        //                     vc.journalDate = Date().plusOffset()
        //                 }
        //                 // FIXME: transit from yearly -> weekly returns to monthly.
        //                 openMonthly = true
        //                 openWeekly = true
        //                 openDaily = false
        //             }
        //         }
    }
    
    func loadStatistics(completion: @escaping (Bool) -> Void) {
        guard !year.isInFuture else {
            self.statistics = nil
            self.isLoading = false
            return
        }
        apiNodeServer.queryStatistics(journalDate: year, timeFrame: .yearly) { (result) in
            DispatchQueue.main.async {
                withAnimation {
                    self.isLoading = false
                    switch result {
                    case .success(let statistics):
                        self.statistics = statistics
                        isDummyData = false
                        completion(true)
                    case .failure:
                        //                        //???: No data view!
                        print("has error on Yearly Report")
                        completion(false)
                    }
                }
            }
        }
    }
}
