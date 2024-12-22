//
//  WeeklyView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/06.
//

import SwiftUI

struct WeeklyReportView: View {
    @EnvironmentObject var weekStore: WeekStore
    
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var msc: MainScreenController
    
    @Binding var timeFrame: StatisticsTimeFrame
    @State var weeklyHasData = Defaults.weeklyHasData
    @State var openDaily = false
    @State var hasError = false
//    @State var statistics: StatisticsResponse?
    @State var scrolled = false
    @State var isLoading = false
    @State var isRefreshing = false
    @State var isDummyData = true
    @State var showDatePicker = false
    //    @State var tokens: [String] = []
    @State var previousDate: Date = Date()
    @State var offset: CGFloat = 0
    
    private let apiNodeServer = ApiNodeServer()
    
    var body: some View {
        ZStack {
            if scrolled {
                Color.white
            } else {
                gradientBackground
            }
            TrackableScrollView(showIndicators: false, contentOffset: $offset) {
                    ScrollViewReader { reader in
                        VStack(spacing: 0) {
                            Color.clear.frame(height: 1)
                                .id("top")
                            if isRefreshing {
                                ProgressView()
                                    .frame(height: Size.w(60))
                            }
                            
                            ZStack {
                                VStack(spacing: 0) {
                                    HStack(alignment: .bottom, spacing: Size.w(9.8)) {
                                        ForEach(0..<7, id:\.self) { index in
                                            Text(LocalizedStringKey(weekDays[index]))
                                                .foregroundColor(.gray300)
                                                .font(semiBold14Font)
                                                .tracking(-1)
                                                .lineLimit(1)
                                                .frame(width: Size.w(36))
                                        }
                                    }
                                    ZStack {
                                        BarChartGrid(scrolled: $scrolled,
                                                     yAxis: scrolled ? yAxisPlaceholder
                                                     : weekStore.statistics?.sleepStages.getStatisticsYAxisSteps() ?? yAxisPlaceholderS)
                                        .padding(.top, Size.w(53))
                                        
                                        WeeksTabView(openDaily: $openDaily, scrolled: $scrolled)
                                    }
                                }
                            }
//                            .background(scrolled ? gradientBackground : LinearGradient(colors: [.clear], startPoint: .top, endPoint: .bottom))
                            .frame(width: .infinity).ignoresSafeArea()
                            .padding(.top, Size.w(20))
                            
                            
                            if !scrolled {
                                ReportTokensView(outputSummaryTokens: getTokens().tokens, hasError: hasError, averageQuality: weekStore.statistics?.getAverageQuality() ?? "--%")
                                    .redacted(reason: isLoading ? .placeholder : [])
                                CoachView(recs: getTokens().recs, weeklyHasData: weeklyHasData, hasError: hasError, isLoading: isLoading)
                            } else {
                                if let statistics = weekStore.statistics {
                                    VStack(spacing: Size.h(22)) {
                                        ExplanationView(duration: Double(statistics.sleepStages.getAverageSleepDuration()),
                                                        debts: statistics.sleepDebt ?? [-121, 111, -6, 121, -19, 133, -69])
                                        Cumulative(debt: statistics.getDebtSum() ?? -134)
                                            .padding(.horizontal, Size.w(16))
                                        SleepBoxesView(sleepStart: statistics.sleepStages.getAverageSleepStart(),
                                                       sleepEnd: statistics.sleepStages.getAverageSleepEnd())
                                        WeeklyVitalAndEnv(statistics: statistics)
                                    }
                                }
                            }
                        }
                        .onChange(of: vc.refreshReportScreen) { _ in
                            withAnimation {
                                reader.scrollTo("top", anchor: .top)
                            }
                        }
                        .onChange(of: offset) { value in
                            if value < -80 {
                                refresh()
                            }
                            if hasError { return }
                            if value > 5 && !scrolled && weekStore.statistics != nil {
                                DispatchQueue.main.async {
                                    withAnimation {
                                        scrolled = true
                                    }
                                }
                            } else if value <= 5 && scrolled {
                                DispatchQueue.main.async {
                                    withAnimation {
                                        scrolled = false
                                    }
                                }
                            }
                        }
                        .onChange(of: weekStore.selectedDate) { value in
                            withAnimation {
                                reader.scrollTo("top", anchor: .top)
                            }
                        }
                    }
//                }
            }
            .frame(width: UIScreen.main.bounds.width)
//            .disabled(statistics == nil)
//            .disabled(!weeklyHasData)
            .disabled(isRefreshing)
        }
        .background((scrolled ? LinearGradient(colors: [.white], startPoint: .top, endPoint: .bottom) : gradientBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(
            Text(Calendar.current.component(.weekOfMonth, from: weekStore.selectedDate).toWeekNumber()) +
            Text(LocalizedStringKey(weekStore.selectedDate.toString(dateFormat: "MMM")))
                .foregroundColor(.white)
        )
        .navigationBarItems(leading: Button(action: {
            timeFrame = .monthly
        }) {
            Image("ic-calendar-monthly")
                .resizable()
                .scaledToFit()
                .frame(width: Size.w(44), height: Size.w(44))
        }, trailing:
                                Button(action: {
            DispatchQueue.main.async {
                withAnimation {
                    weekStore.selectedDate = Date().startOfDay
                }
            }
        }) {
            Text("TODAY")
                .font(medium16Font)
                .foregroundColor(.gray800)
        }
                            
            .disabled(weekStore.selectedDate.isSameWeek(date2: Date()))
            .opacity(weekStore.selectedDate.isSameWeek(date2: Date()) ? 0.5 : 1)
        )
        .onAppear {
//            getData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if !Defaults.reportWasShown {
                    withAnimation {
                        vc.state = .coach(type: .report)
                    }
                }
            }
        }
    }
    
    func refresh() {
        isRefreshing = true
        if Defaults.presentationMode {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    isRefreshing = false
                }
            }
        } else {
            weekStore.loadStatistics() {_ in
                withAnimation {
                    isRefreshing = false
                }
            }
        }
    }
    
    /// deprecated
//    func getData() {
//        if Defaults.presentationMode {
//            self.statistics = ellie
//            isDummyData = false
//        } else {
//            if isDummyData {
////                self.statistics = weeklyPlaceholder
//                isLoading = true
//                loadStatistics() {_ in }
//            }
//        }
//    }
    
//    func loadStatistics(completion: @escaping (Bool) -> Void) {
//        hasError = false
//        isDummyData = true
//        let convertedDate = vc.journalDate.plusOffset().endOfWeek
//        let statisticsRealm = StatisticsResponse.loadFromRealm(date: convertedDate, timeFrame: .weekly)
//        if let statisticsRealm {
//            DispatchQueue.main.async {
//                Defaults.weeklyHasData = true
//                weeklyHasData = true
//                isLoading = false
//                self.statistics = statisticsRealm
//                isDummyData = false
//                completion(true)
//            }
//        } else {
//            apiNodeServer.queryStatistics(journalDate: vc.journalDate, timeFrame: .weekly) { (result) in
//                DispatchQueue.main.async {
//                    withAnimation {
//                        switch result {
//                        case .success(let statistics):
//                            if statistics.sleepQuality.allSatisfy({ $0 == 0 }) {
//                                print("No Data(Empty Sleep Quality Array)")
//                                self.statistics = nil
//                                completion(false)
//                            } else {
//                                Defaults.weeklyHasData = true
//                                weeklyHasData = true
//                                self.statistics = statistics
//                                saveRealm(date: convertedDate, statistics: statistics)
//                                isDummyData = false
//                                completion(true)
//                            }
//                        case .failure(let error):
//                            print(error)
//                            if error as! ApiError == ApiError.invalidJSON {
//                                self.statistics = nil
//                                completion(false)
//                            } else if error as! ApiError == ApiError.httpError {
//                                self.statistics = nil
//                                hasError = true
//                                completion(false)
//                            }
//                        }
//                        isLoading = false
//                    }
//                }
//            }
//        }
//    }
    
//    private func saveRealm(date: Date, statistics: StatisticsResponse) {
//        let isCurrentPeriod: ComparisonResult = Calendar.current.compare(Date().plusOffset(), to: date, toGranularity: .weekOfYear)
//        if isCurrentPeriod == .orderedDescending {
//            StatisticsResponse.saveToRealm(statistics: statistics, timeframe:  StatisticsTimeFrame.weekly.rawValue, requestedDate: date)
//        }
//    }
    
    func getTokens() -> (tokens: [String], recs: [String]) {
        if let statistics = msc.statistics, let recs = statistics.recommendations {
            
            let tokens = recs.sorted(by: { $0.token > $1.token }).map { $0.token }
            let reccom = recs.sorted(by: { $0.recommendation > $1.recommendation }).map { $0.recommendation }
            return (tokens, reccom)
        } else if hasError {
            return (["Error"], [])
        } else {
            return (["No Data"], [])
        }
    }
}
