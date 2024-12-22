//
//  WeekStore.swift
//  InfiniteWeekView
//
//  Created by Philipp Knoblauch on 13.05.23.
//

import SwiftUI

class WeekStore: ObservableObject {
    @Published var weeks: [Week] = []
    @Published var selectedDate: Date {
        didSet {
            calcWeeks(with: selectedDate)
//            loadStatistics() { bool in }
            getData()
        }
    }

    @Published var statistics: StatisticsResponse? = nil
    
    init(with date: Date = Date().startOfDay) {
        self.selectedDate = Calendar.current.startOfDay(for: date)
        calcWeeks(with: selectedDate)
        getData()
//        loadStatistics() { bool in }
    }

    private func calcWeeks(with date: Date) {
        weeks = [
            week(for: Calendar.current.date(byAdding: .day, value: -7, to: date)!, with: -1),
            week(for: date, with: 0),
            week(for: Calendar.current.date(byAdding: .day, value: 7, to: date)!, with: 1)
        ]
    }

    private func week(for date: Date, with index: Int) -> Week {
        var result: [Date] = .init()

        guard let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) else { return .init(index: index, dates: [], referenceDate: date) }

        (0...6).forEach { day in
            if let weekday = Calendar.current.date(byAdding: .day, value: day, to: startOfWeek) {
                result.append(weekday)
            }
        }

        return .init(index: index, dates: result, referenceDate: date)
    }

    func selectToday() {
        select(date: Date())
    }

    func select(date: Date) {
        selectedDate = Calendar.current.startOfDay(for: date)
    }

    func update(to direction: TimeDirection) {
        switch direction {
        case .future:
            selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: selectedDate)!

        case .past:
            selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate)!

        case .unknown:
            selectedDate = selectedDate
        }
        calcWeeks(with: selectedDate)
    }
    
    func getData() {
        if Defaults.presentationMode {
            self.statistics = ellie
//            isDummyData = false
        } else {
//            if isDummyData {
                //                self.statistics = weeklyPlaceholder
//                isLoading = true
                loadStatistics() {_ in }
//            }
        }
    }
    
    func loadStatistics(completion: @escaping (Bool) -> Void) {
        self.statistics = nil
        guard !selectedDate.isInFuture else { return }
        let apiNodeServer = ApiNodeServer()

        let convertedDate = selectedDate.plusOffset().endOfWeek
        let statisticsRealm = StatisticsResponse.loadFromRealm(date: convertedDate, timeFrame: .weekly)
        if let statisticsRealm {
            DispatchQueue.main.async {
                Defaults.weeklyHasData = true
//                weeklyHasData = true
//                isLoading = false
                withAnimation {
                    self.statistics = statisticsRealm
                }
                
//                isDummyData = false
                completion(true)
            }
        } else {
            apiNodeServer.queryStatistics(journalDate: selectedDate, timeFrame: .weekly) { (result) in
                DispatchQueue.main.async {
                    withAnimation {
                        switch result {
                        case .success(let statistics):
                            if statistics.sleepQuality.allSatisfy({ $0 == 0 }) {
                                print("No Data(Empty Sleep Quality Array)")
                                self.statistics = nil
                                completion(false)
                            } else {
                                Defaults.weeklyHasData = true
//                                weeklyHasData = true
                                withAnimation {
                                    self.statistics = statistics
                                }
                                
                                self.saveRealm(date: convertedDate, statistics: statistics)
//                                isDummyData = false
                                completion(true)
                            }
                        case .failure(let error):
                            print(error)
                            if error as! ApiError == ApiError.invalidJSON {
                                self.statistics = nil
                                completion(false)
                            } else if error as! ApiError == ApiError.httpError {
                                self.statistics = nil
//                                hasError = true
                                completion(false)
                            }
                        }
//                        isLoading = false
                    }
                }
            }
        }
    }
    
    private func saveRealm(date: Date, statistics: StatisticsResponse) {
        let isCurrentPeriod: ComparisonResult = Calendar.current.compare(Date().plusOffset(), to: date, toGranularity: .weekOfYear)
        if isCurrentPeriod == .orderedDescending {
            StatisticsResponse.saveToRealm(statistics: statistics, timeframe:  StatisticsTimeFrame.weekly.rawValue, requestedDate: date)
        }
    }
}
