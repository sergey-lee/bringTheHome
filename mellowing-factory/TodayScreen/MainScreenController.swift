//
//  MainScreenController.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/01.
//

import SwiftUI
import Amplify
import RevenueCat

enum DebtStatus {
    case debt, optimal, surplus
}

class MainScreenController: ObservableObject {
    @Published var statistics: StatisticsResponse?
    
    @Published var details: Bool = false
    @Published var pulledUp: Bool = false
    @Published var sleepDebt: Double = 0
    @Published var debtOffset: CGFloat = 0
    @Published var debtStatus: DebtStatus = .optimal
    @Published var statusForFace: Int = 2
    @Published var isLoading = false
    @Published var isRedacting = false
    @Published var refreshed = false
    @Published var tokens: [Recommendation]?
    
    @Published var summaryData = [
        SummaryModel("summary-heart1", "-- Bpm", "HEART_RATE", false),
        SummaryModel("summary-lungs1", "-- Bpm", "BREATHING_RATE", false),
        SummaryModel("summary-temperature2", "-- \(temperatureList[Defaults.temperatureUnit])", "TEMPERATURE", false),
        SummaryModel("summary-humid2", "-- %", "HUMIDITY", false),
        SummaryModel("summary-noise1", "-- dB", "NOISE", false)
    ]
    
    @Published var idOfChangedAvatar = ""
    
    private let apiNodeServer = ApiNodeServer()

    init() {
        self.isLoading = true
        
        if Defaults.presentationMode {
            self.statistics = ellieMain
            self.setupUI()
            withAnimation {
                self.isLoading = false
            }
        } else {
            if statistics == nil {
                self.loadStatistics { response in
                    DispatchQueue.main.async {
                        self.statistics = response
                        self.setupUI()
                        withAnimation {
                            self.isLoading = false
                        }
                    }
                }
            } else {
                self.isLoading = false
            }
        }
    }
    
    func refresh() {
        if Defaults.presentationMode {
            self.isRedacting = true
            self.refreshed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isRedacting = false
                self.refreshed = false
            }
        } else {
            self.isRedacting = true
            self.loadStatistics { response in
                self.statistics = nil
                self.refreshed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation {
                        self.statistics = response
                        self.setupUI()
                        self.isRedacting = false
                        self.refreshed = false
                    }
                }
            }
        }
    }
    
    
    func loadStatistics(completion: @escaping (StatisticsResponse?) -> Void) {
//        completion(grandfather)
//        if statistics == nil {
            apiNodeServer.queryStatistics(timeFrame: .weekly) { (result) in
                switch result {
                case .success(let statistics):
                    completion(statistics)
                case .failure:
                    print("has error on main")
                    completion(nil)
                }
            }
//        }
    }

    private func setupUI() {
        if let statistics {
            if let sleepQuality = statistics.sleepQuality.last {
                if sleepQuality > 79 {
                    self.statusForFace = 1
                } else if sleepQuality > 60 {
                    self.statusForFace = 2
                } else {
                    self.statusForFace = 3
                }
                
                if sleepQuality == 0 {
                    self.statusForFace = 2
                }
            }
            
            if let sleepDebtArray = statistics.sleepDebt {
                self.sleepDebt = sleepDebtArray.reduce(0, +)
            }
            
            let debtPoint: Double = 150 / 135
            self.debtOffset = Size.w(self.sleepDebt / debtPoint)
            let limitOffset: Double = 135
            
            if sleepDebt > limitOffset {
                self.debtOffset = limitOffset
            }
            if sleepDebt < -limitOffset {
                self.debtOffset = -limitOffset
            }
            
            if sleepDebt > 30 {
                self.debtStatus = .debt
            } else if sleepDebt < -30 {
                self.debtStatus = .surplus
            }
            
            self.summaryData = [
                statistics.getHeart(),
                statistics.getBreathing(),
                statistics.getTemperature(),
                statistics.getHumid(),
                statistics.getNoise()
            ]

            self.tokens = statistics.recommendations
        }
    }
}
