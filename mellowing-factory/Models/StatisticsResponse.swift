//
//  StatisticsResponse.swift
//  mellowing-factory
//
//  Created by 준녕 on 22.93.17.
//

import Foundation
import RealmSwift
import SwiftUI

struct StatisticsResponse: Codable, Equatable {
    static func == (lhs: StatisticsResponse, rhs: StatisticsResponse) -> Bool {
        return lhs.id == rhs.id && lhs.updated == rhs.updated
    }
    
    let id: String?
    let created: String?
    var sleepStages: SleepStageResult
    var radarValues: [[Double]]
    var heartRate: SignalResult
    var breathingRate: SignalResult
    var sleepQuality: [Int]
    var sleepLatency: [Int]
    var lightDuration: [Int]
    var sleepEfficiency: [Int]
    var deepDuration: [Int]
    var remDuration: [Int]
    var wokenDuration: [Int]
    var wakeUpState: [Int]
    var updated: String?
    var percentageChangeRadar: [Double]?
    var sleepDebt: [Double]?
    var temperature: SignalResult?
    var humidity: SignalResult?
    var audio: SignalResult?
    var bcgRange: SignalResult?
    var recommendations: [Recommendation]?
    
    // TODO: need to do analysis per point (for when user clicks on each point of radar)
    // TODO: need to generate up/down arrows & values for change since last week
    func lastWeekData() -> [Double] {
        let lastWeekDSD: Double = calculateMean(array: getColumnValues(matrix: Array(radarValues[0...5]), index: 0))
        let lastWeekSE: Double = calculateMean(array: getColumnValues(matrix: Array(radarValues[0...5]), index: 1))
        let lastWeekSL: Double = calculateMean(array: getColumnValues(matrix: Array(radarValues[0...5]), index: 2))
        let lastWeekWS: Double = calculateMean(array: getColumnValues(matrix: Array(radarValues[0...5]), index: 3))
        let lastWeekSD: Double = calculateMean(array: getColumnValues(matrix: Array(radarValues[0...5]), index: 4))
        return [lastWeekDSD, lastWeekSE, lastWeekSL, lastWeekWS, lastWeekSD]
    }
    
    func calculateMean(array: [Double]) -> Double {
        let arrayWithoutNaN = array.filter{$0 > 0}
        let sum = arrayWithoutNaN.reduce(0, { a, b in
            return a + b
        })
        let count = arrayWithoutNaN.count
        let mean = Double(sum) / Double(count)
        return mean.isNaN ? 0 : Double(mean)
    }

    func calculateElementDifference(array: [Int]) -> [Int] {
        let newArray = array.filter{$0 > 0}
        return zip(newArray.dropFirst(), newArray).map(-)
    }

    func returnMaxPriorityIndex(array: [Int]) -> [Int] {
        var indices: [Int] = []
        for (index, value) in array.enumerated() {
            if value == 2 {
                indices.append(index)
            }
        }
        return indices
    }

    func returnMediumPriorityIndex(array: [Int]) -> [Int] {
        var indices: [Int] = []
        for (index, value) in array.enumerated() {
            if value == 1 {
                indices.append(index)
            }
        }
        return indices
    }
    
    func returnLowPriorityIndex(array: [Int]) -> [Int] {
        var indices: [Int] = []
        for (index, value) in array.enumerated() {
            if value == 0 {
                indices.append(index)
            }
        }
        return indices
    }
    
    func getColumnValues(matrix: [[Double]], index: Int) -> [Double] {
        var columnValues: [Double] = []
        for row in matrix {
            columnValues.append(row[index])
        }
        return columnValues
    }
    
    func getHeart() -> SummaryModel {
        var model = SummaryModel("summary-heart2", "-- Bpm", "HEART_RATE", true, noData: true)
        
        if let min = heartRate.minValue.last {
            if let max = heartRate.maxValue.last {
                model.noData = false
                if min != 0 && max != 0 {
                    model.data = "\(Int(min))-\(Int(max)) Bpm"
                    if min > 40 && max < 140 {
                        model.isNegative = false
                        model.image = "summary-heart1"
                    }
                }
            }
        }
        return model
    }
    
    func getBreathing() -> SummaryModel {
        var model = SummaryModel("summary-lungs2", "-- Bpm", "BREATHING_RATE", true, noData: true)
        
        if let min = breathingRate.minValue.last {
            if let max = breathingRate.maxValue.last {
                model.noData = false
                if min != 0 && max != 0 {
                    model.data = "\(Int(min))-\(Int(max)) Bpm"
                    if min > 4 && max < 30 {
                        model.isNegative = false
                        model.image = "summary-lungs1"
                    }
                }
            }
        }
        
        return model
    }
    
    func getBioColor(title: String) -> Color {
        if title == "BREATHING_RATE" {
            if let min = breathingRate.minValue.last {
                if let max = breathingRate.maxValue.last {
                    if min != 0 && max != 0 {
                        if min < 4 || max > 30 {
                            return Color.red700
                        }
                    }
                }
            }
        } else {
            if let min = heartRate.minValue.last {
                if let max = heartRate.maxValue.last {
                    if min != 0 && max != 0 {
                        if min < 40 || max > 140 {
                            return Color.red700
                        }
                    }
                }
            }
        }
        
        return Color.gray800
    }

    func getTemperature() -> SummaryModel {
        //        return SummaryModel("summary-temperature2", "73.4 °F", "Temperature", false)
        var model = SummaryModel("summary-temperature1", "-- \(temperatureList[Defaults.temperatureUnit])", "TEMPERATURE", false, noData: true)
        if let temperature {
            guard !temperature.average.allSatisfy({ $0 == 0 }) else { return model }
            guard !temperature.average.isEmpty else { return model }
            
            let average = temperature.average.last!.fahrenheit
            
            model.data = "\(Int(average))\(temperatureList[Defaults.temperatureUnit])"
            model.noData = false
            if average < 24.fahrenheit && average >= 20.fahrenheit {
                model.isNegative = false
                model.image = "summary-temperature2"
            } else {
                model.isNegative = true
                model.image = "summary-temperature3"
            }
        }
        return model
    }
    
    func getHumid() -> SummaryModel {
//        return SummaryModel("summary-humid2", "35%", "Humidity", false)
        var model = SummaryModel("summary-humid1", "-- %", "HUMIDITY", false, noData: true)

        if let humidity {
            guard !humidity.average.allSatisfy({ $0 == 0 }) else { return model }
            guard !humidity.average.isEmpty else { return model }
            
            let average = humidity.average.last!
            model.data = "\(Int(average))%"
            model.noData = false
            if average < 50 && average >= 30 {
                model.isNegative = false
                model.image = "summary-humid2"
            } else {
                model.isNegative = true
                model.image = "summary-humid3"
            }
        }
        return model
    }
    
    func getNoise() -> SummaryModel {
//        return SummaryModel("summary-noise1", "12dB", "Noise", false)
        var model = SummaryModel("summary-noise2", "-- dB", "NOISE", false, noData: true)
        if let audio {
            guard !audio.average.allSatisfy({ $0 == 0 }) else { return model }
            guard !audio.average.isEmpty else { return model }
            let average = audio.average.last!
            model.data = "\(Int(average))dB"
            model.noData = false
            if average < 20 {
                model.isNegative = false
                model.image = "summary-noise1"
            } else if average >= 30 {
                model.isNegative = true
                model.image = "summary-noise3"
            }
        }
        return model
    }
    
    func getAverageDuration() -> Int {
        let sum = sleepStages.sleepDuration.filter{ $0 > 0 }.reduce(0, +)
        if sum != 0 {
            return sum / sleepQuality.filter{ $0 > 0 }.count
        } else {
            return 0
        }
    }
    
    func getAverageQuality() -> Int {
        let sum = sleepQuality.filter{ $0 > 0 }.reduce(0, +)
        if sum != 0 {
            return sum / sleepQuality.filter{ $0 > 0 }.count
        } else {
            return 0
        }
    }
    
    func getAverageQuality() -> String {
        let sum = sleepQuality.filter{ $0 > 0 }.reduce(0, +)
        if sum != 0 {
            let average = sum / sleepQuality.filter{ $0 > 0 }.count
            return average > 0 ? "\(average)%" : "--%"
        } else {
            return "--%"
        }
    }
    
    func getDebtSum() -> Double? {
        if let sleepDebt {
            return sleepDebt.filter{ $0 != 0 }.reduce(0, +)
        } else {
            return nil
        }
    }
    
    func getAverageDebt() -> Double? {
        if let sleepDebt {
            let sum = sleepDebt.filter{ $0 != 0 }.reduce(0, +)
            return abs(sum) > 0 ? sum / Double(sleepDebt.filter{ $0 > 0 }.count) : nil
        } else {
            return nil
        }
    }
    
    func getAverageRadar() -> [Double] {
        let radars = radarValues.filter { $0 != [] && $0 != [0,0,0,0,0] }
        var result: [Double] = []
        for i in 0..<radars[0].count {
            var num: Double = 0
            for j in 0..<radars.count {
                num += radars[j][i]
            }
            result.append(num / Double(radars.count))
        }
        return result
    }
    
    func getSummOfChanges() -> Double? {
        if let percentageChangeRadar {
//            return percentageChangeRadar.filter{ $0 != 0 }.reduce(0, +)
            return percentageChangeRadar.filter{ $0 != 0 }.map { Double($0)/5 }.reduce(0, +)
        } else {
            return nil
        }
    }
    
    static func loadFromRealm(date: Date, timeFrame: StatisticsTimeFrame) -> StatisticsResponse? {
        if let realm = try? Realm() {
            let list = realm.objects(StatisticsResponseRealm.self).filter {
                if let requestedDate = $0.requestedDate {
                    return requestedDate.isSameDay(date2: date)
                } else { return false }
            }.filter {
//                !$0.sleepQuality.allSatisfy({$0 == 0}) &&
                $0.timeFrame == timeFrame.rawValue
            }
            
            if !list.isEmpty {
                print("Stat.Res./loadFromRealm: \(date), timeframe: \(timeFrame.rawValue)")
                let statisticsRealm = list.first!
                
                let heartRateResult = SignalResult(values: Array(statisticsRealm.heartRate!.values),
                                                      variability: Array(statisticsRealm.heartRate!.variability),
                                                      maxValue: Array(statisticsRealm.heartRate!.maxValue),
                                                   minValue: Array(statisticsRealm.heartRate!.minValue),
                                                   average: Array(statisticsRealm.heartRate!.average))
                
                let breathingRateResult = SignalResult(values: Array(statisticsRealm.breathingRate!.values),
                                                          variability: Array(statisticsRealm.breathingRate!.variability),
                                                          maxValue: Array(statisticsRealm.breathingRate!.maxValue),
                                                          minValue: Array(statisticsRealm.breathingRate!.minValue),
                                                       average: Array(statisticsRealm.breathingRate!.average))
                // TODO: refactor this!
                var humidityResult: SignalResult? = nil
                if let humidity = statisticsRealm.humidity {
                    humidityResult = SignalResult(values: Array(humidity.values),
                                                  variability: Array(humidity.variability),
                                                  maxValue: Array(humidity.maxValue),
                                                  minValue: Array(humidity.minValue),
                                                  average: Array(humidity.average))
                }
                
                var audioResult: SignalResult? = nil
                if let audio = statisticsRealm.audio {
                    audioResult = SignalResult(values: Array(audio.values),
                                                              variability: Array(audio.variability),
                                                              maxValue: Array(audio.maxValue),
                                                              minValue: Array(audio.minValue),
                                                           average: Array(audio.average))
                }
                
                var temperatureResult: SignalResult? = nil
                if let temperature = statisticsRealm.temperature {
                    temperatureResult = SignalResult(values: Array(temperature.values),
                                                     variability: Array(temperature.variability),
                                                     maxValue: Array(temperature.maxValue),
                                                     minValue: Array(temperature.minValue),
                                                     average: Array(temperature.average))
                }
                
                var bcgRangeResult: SignalResult? = nil
                if let bcgRange = statisticsRealm.bcgRange {
                    bcgRangeResult = SignalResult(values: Array(bcgRange.values),
                                                  variability: Array(bcgRange.variability),
                                                  maxValue: Array(bcgRange.maxValue),
                                                  minValue: Array(bcgRange.minValue),
                                                  average: Array(bcgRange.average))
                }
                
                var listOfStages: [[Int]] = []
                if let stages = statisticsRealm.sleepStages?.sleepStages {
                    for stage in stages {
                        listOfStages.append(Array(stage.values))
                    }
                }
                
                let sleepStages = SleepStageResult(sleepStart: Array(statisticsRealm.sleepStages!.sleepStart),
                                                   sleepEnd: Array(statisticsRealm.sleepStages!.sleepEnd),
                                                   sleepDuration: Array(statisticsRealm.sleepStages!.sleepDuration),
                                                   sleepStages: listOfStages)
                
                var radarValues: [[Double]] = []
                let values = statisticsRealm.radarValues
                
                for value in values {
                    radarValues.append(Array(value.values))
                }
                
                let statisticsRealmToSet = StatisticsResponse(id: statisticsRealm.id,
                                                              created: statisticsRealm.created,
                                                              sleepStages: sleepStages,
                                                              radarValues: radarValues,
                                                              heartRate: heartRateResult,
                                                              breathingRate: breathingRateResult,
                                                              sleepQuality: Array(statisticsRealm.sleepQuality),
                                                              sleepLatency: Array(statisticsRealm.sleepLatency),
                                                              lightDuration: Array(statisticsRealm.lightDuration),
                                                              sleepEfficiency: Array(statisticsRealm.sleepEfficiency),
                                                              deepDuration: Array(statisticsRealm.deepDuration),
                                                              remDuration: Array(statisticsRealm.remDuration),
                                                              wokenDuration: Array(statisticsRealm.wokenDuration),
                                                              wakeUpState: Array(statisticsRealm.wakeUpState),
                                                              percentageChangeRadar: Array(statisticsRealm.percentageChangeRadar),
                                                              sleepDebt: Array(statisticsRealm.sleepDebt),
                                                              temperature: temperatureResult,
                                                              humidity: humidityResult,
                                                              audio: audioResult,
                                                              bcgRange: bcgRangeResult
                )
                return statisticsRealmToSet
            } else {
                return nil
            }
        
        } else {
            deleteFiles(urlsToDelete: getRealmDocs())
            return nil
        }
    }
    
    static func saveToRealm(statistics: StatisticsResponse, timeframe: String, requestedDate: Date) {
        let statisticsResponseRealm = StatisticsResponseRealm()
        
        var radarValues: [RadarValuesRealm] = []
        
        for values in statistics.radarValues {
            let radar = RadarValuesRealm()
            radar.values.append(objectsIn: values)
            radarValues.append(radar)
        }

        statisticsResponseRealm.timeFrame = timeframe
        statisticsResponseRealm.requestedDate = requestedDate
        statisticsResponseRealm.created = statistics.created
        statisticsResponseRealm.updated = statistics.updated
        statisticsResponseRealm.sleepQuality.append(objectsIn: statistics.sleepQuality)
        statisticsResponseRealm.sleepEfficiency.append(objectsIn: statistics.sleepEfficiency)
        statisticsResponseRealm.lightDuration.append(objectsIn: statistics.lightDuration)
        statisticsResponseRealm.deepDuration.append(objectsIn: statistics.deepDuration)
        statisticsResponseRealm.remDuration.append(objectsIn: statistics.remDuration)
        statisticsResponseRealm.wokenDuration.append(objectsIn: statistics.wokenDuration)
        statisticsResponseRealm.radarValues.append(objectsIn: radarValues)
        statisticsResponseRealm.wakeUpState.append(objectsIn: statistics.wakeUpState)
        statisticsResponseRealm.sleepLatency.append(objectsIn: statistics.sleepLatency)
        statisticsResponseRealm.sleepDebt.append(objectsIn: statistics.sleepDebt ?? [])
        
        let heartRateResult = SignalResultRealm()
        heartRateResult.maxValue.append(objectsIn: statistics.heartRate.maxValue)
        heartRateResult.minValue.append(objectsIn: statistics.heartRate.minValue)
        heartRateResult.values.append(objectsIn: statistics.heartRate.values)
        heartRateResult.variability.append(objectsIn: statistics.heartRate.variability)
        heartRateResult.average.append(objectsIn: statistics.heartRate.average)

        let breathRateResult = SignalResultRealm()
        breathRateResult.maxValue.append(objectsIn: statistics.breathingRate.maxValue)
        breathRateResult.minValue.append(objectsIn: statistics.breathingRate.minValue)
        breathRateResult.values.append(objectsIn: statistics.breathingRate.values)
        breathRateResult.variability.append(objectsIn: statistics.breathingRate.variability)
        breathRateResult.average.append(objectsIn: statistics.breathingRate.average)
        
        if let temperature = statistics.temperature {
            let temperatureResult = SignalResultRealm()
            temperatureResult.maxValue.append(objectsIn: temperature.maxValue)
            temperatureResult.minValue.append(objectsIn: temperature.minValue)
            temperatureResult.values.append(objectsIn: temperature.values)
            temperatureResult.variability.append(objectsIn: temperature.variability)
            temperatureResult.average.append(objectsIn: temperature.average)
            statisticsResponseRealm.temperature = temperatureResult
        }
        
        if let humidity = statistics.humidity {
            let humidityResult = SignalResultRealm()
            humidityResult.maxValue.append(objectsIn: humidity.maxValue)
            humidityResult.minValue.append(objectsIn: humidity.minValue)
            humidityResult.values.append(objectsIn: humidity.values)
            humidityResult.variability.append(objectsIn: humidity.variability)
            humidityResult.average.append(objectsIn: humidity.average)
            statisticsResponseRealm.humidity = humidityResult
        }
        
        if let audio = statistics.audio {
            let audioResult = SignalResultRealm()
            audioResult.maxValue.append(objectsIn: audio.maxValue)
            audioResult.minValue.append(objectsIn: audio.minValue)
            audioResult.values.append(objectsIn: audio.values)
            audioResult.variability.append(objectsIn: audio.variability)
            audioResult.average.append(objectsIn: audio.average)
            statisticsResponseRealm.audio = audioResult
        }
        
        if let bcgRange = statistics.bcgRange {
            let bcgRangeResult = SignalResultRealm()
            bcgRangeResult.maxValue.append(objectsIn: bcgRange.maxValue)
            bcgRangeResult.minValue.append(objectsIn: bcgRange.minValue)
            bcgRangeResult.values.append(objectsIn: bcgRange.values)
            bcgRangeResult.variability.append(objectsIn: bcgRange.variability)
            bcgRangeResult.average.append(objectsIn: bcgRange.average)
            statisticsResponseRealm.bcgRange = bcgRangeResult
        }
        
        statisticsResponseRealm.breathingRate = breathRateResult
        statisticsResponseRealm.heartRate = heartRateResult
        
        var sleepStages: [SleepStagesRealm] = []
        
        for values in statistics.sleepStages.sleepStages {
            let stages = SleepStagesRealm()
            stages.values.append(objectsIn: values)
            sleepStages.append(stages)
        }
        
        let sleepStagesResult = SleepStageResultRealm()
        sleepStagesResult.sleepStart.append(objectsIn: statistics.sleepStages.sleepStart)
        sleepStagesResult.sleepEnd.append(objectsIn: statistics.sleepStages.sleepEnd)
        sleepStagesResult.sleepDuration.append(objectsIn: statistics.sleepStages.sleepDuration)
        sleepStagesResult.sleepStages.append(objectsIn: sleepStages)
        
        statisticsResponseRealm.sleepStages = sleepStagesResult
        
        if let realm = try? Realm() {
            try! realm.write {
                realm.add(
                    statisticsResponseRealm
                )
            }
            print("Successfully saved in realm")
        } else {
            deleteFiles(urlsToDelete: getRealmDocs())
        }
    }
    
    func getStagePercentage() -> [Int] {
        
        if let stages = sleepStages.sleepStages.first {
            guard !stages.isEmpty else { return [0,0,0,0] }
            var result: [Int] = []
            let onePer: Double = Double(stages.count) / Double(100)
            
            for i in 0..<4 {
                result.append(Int(round(Double(stages.filter { $0 == i }.count) / onePer)))
            }
            return result
        } else {
            return getStagePercentageFromSumOfFour()
        }
    }
    
    func getStagePercentageFromSumOfFour() -> [Int] {
        guard !wokenDuration.isEmpty else { return [] }
        guard !remDuration.isEmpty else { return [] }
        guard !lightDuration.isEmpty else { return [] }
        guard !deepDuration.isEmpty else { return [] }
        
        let sum: Double = Double(wokenDuration.last! + remDuration.last! + lightDuration.last! + deepDuration.last!)
        let wokenPercentage = Int(round(Double(wokenDuration.last!) / sum * 100))
        let remPercentage = Int(round(Double(remDuration.last!) / sum * 100))
        let lightPercentage = Int(round(Double(lightDuration.last!) / sum * 100))
        let deepPercentage = Int(round(Double(deepDuration.last!) / sum * 100))
        
        return [wokenPercentage, remPercentage, lightPercentage, deepPercentage]
    }
}

struct QueryStatisticsDataResponse: Codable {
    var data: StatisticsResponse
}

enum Categories {
    case duration, latency, deepsleep, efficiency, wakeupstate, summary
}
