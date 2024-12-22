//
//  JournalResponse.swift
//  mellowing-factory
//
//  Created by Florian Topf on 20.11.21.
//

import SwiftUI
import RealmSwift

struct JournalResponse: Codable {
    let hasPremium: Bool
    let journalDate: String
    
    let sleepQuality: Int
    let sleepEfficiency: Int
    let lightDuration: Int
    let deepDuration: Int
    let remDuration: Int
    let wokenDuration: Int
    
    let heartRateResult: SignalResult
    let breathingRateResult: SignalResult
    let sleepStageResult: SleepStageResult
    let radarValues: [Double]
    // TODO: Remove it after implementing getXaXis function
    let xAxisSteps: [String]
    
    var dates: [Bool]
    
    //    var alarmOnTime: Int
    //    var targetTime: Int
    //    var timerDifference: Int
    var wakeUpState: Int
    
    var biosignalRecommendations: [Recommendation]
    var sleepRecommendations: [Recommendation]
    var radarRecommendations: [Recommendation]
    
    var temperatureResult: SignalResult?
    var humidityResult: SignalResult?
    var audioResult: SignalResult?
//    var bcgRangeResult: SignalResult?
    
    var sleepDebt: Double?
    
    func getXaXis() -> [String] {
        let count = heartRateResult.values.count
        let startHour = sleepStageResult.sleepStart.last!.toHour()
        //        let endHour = sleepStageResult.sleepEnd.last!.toHour()
        
        var counter = startHour
        var arr: [Int] = []
        
        for _ in 0...count {
            if (counter > 24) {
                counter = 1
            }
            if (counter == 0) {
                counter = 24
            }
            
            arr.append(counter)
            counter += 1
        }
        return arr.map { String($0) }
    }
    
    func getStagePercentage() -> [Int] {
        
        if let stages = sleepStageResult.sleepStages.first {
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
        let sum: Double = Double(wokenDuration + remDuration + lightDuration + deepDuration)
        let wokenPercentage = Int(round(Double(wokenDuration) / sum * 100))
        let remPercentage = Int(round(Double(remDuration) / sum * 100))
        let lightPercentage = Int(round(Double(lightDuration) / sum * 100))
        let deepPercentage = Int(round(Double(deepDuration) / sum * 100))
        
        return [wokenPercentage, remPercentage, lightPercentage, deepPercentage]
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
    
    func getStatus() -> Status {
        if let stages = sleepStageResult.sleepStages.first {
            if stages.isEmpty {
                if heartRateResult.values.isEmpty {
                    return .UNKNOWN
                } else {
                    return .BIO
                }
            } else {
                if sleepQuality > 79 {
                    return .GOOD
                } else if sleepQuality > 60 {
                    return .NORMAL
                } else if sleepQuality > 0 {
                    return .BAD
                } else {
                    return .UNKNOWN
                }
            }
        } else {
            return .UNKNOWN
        }
    }
    
    func getStatusColor() -> Color {
        switch getStatus() {
        case .GOOD: return .gray900
        case .NORMAL: return .yellow200
        case .BAD: return .red500
        case .BIO: return .yellow200
        case .UNKNOWN: return .yellow200
        }
    }
    
    //MARK: Deprecated
    func getReducedXAxisSteps() -> [String] {
        var reducedXAxisSteps: [String] = []
        if xAxisSteps.count > 5 {
            for (index, item) in xAxisSteps.enumerated() {
                if index % 2 == 0 {
                    reducedXAxisSteps.append(item)
                }
            }
            return reducedXAxisSteps
        }
        else {
            return xAxisSteps
        }
    }
    
    
    //MARK: Deprecated
    func journalPageSleepLogic() -> (statement2: String, statement3: String, outputSummaryTokens: [String]) {
        var statement2: String = ""
        var statement3: String = ""
        
        var statement2Candidates: [String] = []
        var statement2Priorities: [Int] = []
        var statement3Candidates: [String] = []
        
        var summaryTokens: [String] = []
        var summaryTokensPriorities: [Int] = []
        
        // TODO: todayTone use cases?
        //        var todayTone: String = "MAIN_VIEW.GREETINGS_LOGIC.NORMAL"
        if (sleepQuality >= 90) {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_EXCELLENT")
            summaryTokensPriorities.append(0)
        }
        if (sleepQuality >= 80 && sleepQuality < 90) {
            //            todayTone = "MAIN_VIEW.GREETINGS_LOGIC.GOOD"
            statement2 = "MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_GREAT"
            statement3 = "MAIN_VIEW.GREETINGS_LOGIC.STATEMENT3_KEEP_IT_UP"
        }
        else if (sleepQuality < 60) {
            //            todayTone = "MAIN_VIEW.GREETINGS_LOGIC.BAD"
            // if bad, find out which is bad and explain
        }
        
        
        // find out which radar values are below average
        if radarValues[0] >= 70 && radarValues[0] < 80 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_LOW_DEEP_SLEEP")
            summaryTokensPriorities.append(0)
            statement2Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_IMPROVE_DS")
            statement2Priorities.append(0)
        }
        else if radarValues[0] < 70 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_LOW_DEEP_SLEEP")
            summaryTokensPriorities.append(2)
            statement2Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_NOT_ENOUGH_DS")
            statement2Priorities.append(2)
            statement3Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATMENT3_RECOMMEND_MEDITATION")
        }
        else if radarValues[0] > 90 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_RESTORATIVE")
            summaryTokensPriorities.append(0)
        }
        
        if radarValues[1] >= 70 && radarValues[1] < 80 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_INEFFICIENT")
            summaryTokensPriorities.append(0)
            statement2Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_IMPROVE_SE")
            statement2Priorities.append(0)
            statement3Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATMENT3_RECOMMEND_MEDITATION")
        }
        else if radarValues[1] < 70 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_INEFFICIENT")
            summaryTokensPriorities.append(2)
            statement2Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_BAD_SE")
            statement2Priorities.append(2)
            statement3Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATMENT3_RECOMMEND_CHECK_ENVIRONMENT")
        }
        else if radarValues[1] > 90 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_EFFICIENT")
            summaryTokensPriorities.append(0)
        }
        
        if radarValues[2] >= 70 && radarValues[2] < 80 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_SLOW_TO_SLEEP")
            summaryTokensPriorities.append(0)
            statement2Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_IMPROVE_SL")
            statement2Priorities.append(0)
            statement3Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT3_RECOMMEND_NO_TV")
        }
        else if radarValues[2] < 70 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_SLOW_TO_SLEEP")
            summaryTokensPriorities.append(2)
            statement2Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_HIGH_SL")
            statement2Priorities.append(2)
            statement3Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT3_RECOMMEND_NO_TV")
        }
        else if radarValues[2] > 90 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_FAST_TO_SLEEP")
            summaryTokensPriorities.append(0)
        }
        
        if radarValues[3] >= 70 && radarValues[3] < 80 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_BAD_WAKE_UP")
            summaryTokensPriorities.append(0)
            statement2Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_IMPROVE_WS")
            statement2Priorities.append(0)
            statement3Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT3_RECOMMEND_REGULAR_WAKETIME")
        }
        else if radarValues[3] < 70 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_BAD_WAKE_UP")
            summaryTokensPriorities.append(2)
            statement2Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_BAD_WS")
            statement2Priorities.append(2)
            statement3Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT3_RECOMMEND_REGULAR_WAKETIME")
        }
        else if radarValues[3] > 90 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_GOOD_WAKE_UP")
            summaryTokensPriorities.append(0)
        }
        
        //        print(sleepStageResult.sleepStart[0] + Double(TimeZone.current.secondsFromGMT())/60)
        if radarValues[4] >= 70 && radarValues[4] < 80 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_INSUFFICIENT")
            summaryTokensPriorities.append(0)
            statement2Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_IMPROVE_SD")
            statement2Priorities.append(1)
            statement3Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT3_RECOMMEND_REGULAR_SLEEP")
        }
        else if radarValues[4] < 70 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_INSUFFICIENT")
            summaryTokensPriorities.append(2)
            statement2Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_NOT_ENOUGH_SD")
            statement2Priorities.append(2)
            if sleepStageResult.sleepStart[0] + Double(TimeZone.current.secondsFromGMT()/60) > 1440 {statement3Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT3_RECOMMEND_LONGER_SLEEP")}
            else {
                statement3Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT3_RECOMMEND_REGULAR_SLEEP")}
        }
        else if radarValues[4] > 90 {
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_SUFFICIENT")
            summaryTokensPriorities.append(0)
        }
        
        
        if getStagePercentage()[0] > 20 {
            // 많이 깸
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_WOKEN_TOO_MUCH")
            summaryTokensPriorities.append(2)
            statement2Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_BAD_SE")
            statement2Priorities.append(2)
            statement3Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATMENT3_RECOMMEND_MEDITATION")
        }
        if getStagePercentage()[1] < 5 {
            // 램수면 부족
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_NOT_ENOUGH_REM")
            summaryTokensPriorities.append(1)
        }
        //        // overlaps with radarvalue analysis of deep sleepo
        //        if getStagePercentage()[3] < 5 {
        //            // 깊은 수면 부족
        //            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_LOW_DEEP_SLEEP")
        //            summaryTokensPriorities.append(1)
        //            statement2Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_NOT_ENOUGH_DS")
        //            statement2Priorities.append(1)
        //            statement3Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT3_RECOMMEND_EXERCISE")
        //        }
        if (getStagePercentage()[2] > 70 && getStagePercentage()[0] > 15) || (getStagePercentage()[2] > 80) {
            // 선잠
            summaryTokens.append("MAIN_VIEW.GREETINGS_LOGIC.TOKENS_TOO_MUCH_LS")
            summaryTokensPriorities.append(1)
            statement2Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_NOT_ENOUGH_DS")
            statement2Priorities.append(1)
            statement3Candidates.append("MAIN_VIEW.GREETINGS_LOGIC.STATMENT3_RECOMMEND_CHECK_ENVIRONMENT")
        }
        
        // first check if it's not a good day
        if statement2.count == 0 {
            let highPriorityIndices = returnMaxPriorityIndex(array: statement2Priorities)
            var outputStatement2: String = ""
            var outputStatement3: String = ""
            var count = 0
            for i in highPriorityIndices {
                if count < 1 {
                    outputStatement2 = statement2Candidates[i]
                    outputStatement3 = statement3Candidates[i]
                }
                count += 1
            }
            let mediumPriorityIndices = returnMediumPriorityIndex(array: statement2Priorities)
            for i in mediumPriorityIndices {
                if count < 1 {
                    outputStatement2 = statement2Candidates[i]
                    outputStatement3 = statement3Candidates[i]
                }
                count += 1
            }
            let lowPriorityIndices = returnLowPriorityIndex(array: statement2Priorities)
            for i in lowPriorityIndices {
                if count < 1 {
                    outputStatement2 = statement2Candidates[i]
                    outputStatement3 = statement3Candidates[i]
                }
                count += 1
            }
            statement2 = outputStatement2
            statement3 = outputStatement3
        }
        // if still nothing is not too bad, do the standard
        if statement2.count == 0 {
            statement2 = "MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_NOT_BAD"
            statement3 = "MAIN_VIEW.GREETINGS_LOGIC.STATEMENT3_RECOMMEND_REGULAR_SLEEP"
        }
        
        //        print("journal response tokens")
        //        print(summaryTokens)
        // update tokens based on conditions and priorities
        let highPriorityIndices = returnMaxPriorityIndex(array: summaryTokensPriorities)
        var outputSummaryTokens: [String] = []
        var count = 0
        for i in highPriorityIndices {
            if count < 4 {
                outputSummaryTokens.append(summaryTokens[i])
            }
            count += 1
        }
        if count < 4 {
            let mediumPrioritiesIndices = returnMediumPriorityIndex(array: summaryTokensPriorities)
            for i in mediumPrioritiesIndices {
                if count < 4 {
                    outputSummaryTokens.append(summaryTokens[i])
                }
                count += 1
            }
        }
        if count < 4 {
            let lowPrioritiesIndices2 = returnLowPriorityIndex(array: summaryTokensPriorities)
            for i in lowPrioritiesIndices2 {
                if count < 4 {
                    outputSummaryTokens.append(summaryTokens[i])
                }
                count += 1
            }
        }
        
        // TODO: if you didnt have sleep today, reset the analysis
        if sleepQuality == 0 {
            statement2 = "MAIN_VIEW.GREETINGS_LOGIC.STATEMENT2_NO_DATA"
            statement3 = "MAIN_VIEW.GREETINGS_LOGIC.STATEMENT3_NO_DATA"
            outputSummaryTokens = ["MAIN_VIEW.GREETINGS_LOGIC.TOKENS_NO_DATA"]
        }
        //        print(outputSummaryTokens)
        if outputSummaryTokens.count == 0 {
            outputSummaryTokens = ["MAIN_VIEW.GREETINGS_LOGIC.TOKENS_NORMAL"]
        }
        if outputSummaryTokens.count == 1 {
            outputSummaryTokens.append("")
            outputSummaryTokens.append("")
        }
        if outputSummaryTokens.count == 2 {
            outputSummaryTokens.append("")
        }
        
        // TODO: remove conflicting tokens
        
        
        return (statement2, statement3, outputSummaryTokens)
    }
    
    // MARK: Deprecated
    func journalPageBiosignalLogic() -> (statement2: String, statement3: String, outputSummaryTokens: [String]) {
        var statement2: String = ""
        var statement3: String = ""
        
        var statement2Candidates: [String] = []
        var statement2Priorities: [Int] = []
        
        var biosignalTokens: [String] = []
        var biosignalTokensPriorities: [Int] = []
        // biosignal token logic
        if (Int(heartRateResult.maxValue.last ?? 0) < 120 && heartRateResult.getMeanValue() < 90 && Int(heartRateResult.minValue.last ?? 0) > 40 && heartRateResult.getMeanValue() > 48) {
            biosignalTokens.append("JOURNAL_VIEW.BIOSIGNAL_TOKENS_NORMAL_HR")
            biosignalTokensPriorities.append(1)
        }
        if (Int(heartRateResult.maxValue.last ?? 0) > 120 || heartRateResult.getMeanValue() > 90) {
            biosignalTokens.append("JOURNAL_VIEW.BIOSIGNAL_TOKENS_HIGH_HR")
            biosignalTokensPriorities.append(2)
            statement2Candidates.append("JOURNAL_VIEW.BIOSIGNAL_INTERP_HIGH_HR")
            statement2Priorities.append(1)
        }
        if (Int(heartRateResult.minValue.last ?? 0) < 40 || heartRateResult.getMeanValue() < 48) {
            biosignalTokens.append("JOURNAL_VIEW.BIOSIGNAL_TOKENS_LOW_HR")
            biosignalTokensPriorities.append(1)
        }
        if (Int(heartRateResult.minValue.last ?? 0) < 40 || heartRateResult.getMeanValue() < 44) {
            biosignalTokens.append("JOURNAL_VIEW.BIOSIGNAL_TOKENS_EXTREME_LOW_HR")
            biosignalTokensPriorities.append(2)
            statement2Candidates.append("JOURNAL_VIEW.BIOSIGNAL_INTERP_EXTREME_LOW_HR")
            statement2Priorities.append(2)
        }
        if (heartRateResult.getMeanVariability() > 20) {
            biosignalTokens.append("JOURNAL_VIEW.BIOSIGNAL_TOKENS_HIGH_HRV")
            biosignalTokensPriorities.append(2)
            statement2Candidates.append("JOURNAL_VIEW.BIOSIGNAL_INTERP_HIGH_HRV")
            statement2Priorities.append(1)
        }
        if (Int(breathingRateResult.maxValue.last ?? 0) < 25 && breathingRateResult.getMeanValue() < 20 && Int(breathingRateResult.minValue.last ?? 0) > 5 && breathingRateResult.getMeanValue() > 8) {
            biosignalTokens.append("JOURNAL_VIEW.BIOSIGNAL_TOKENS_NORMAL_BR")
            biosignalTokensPriorities.append(1)
        }
        if (Int(breathingRateResult.maxValue.last ?? 0) > 25 || breathingRateResult.getMeanValue() > 20) {
            biosignalTokens.append("JOURNAL_VIEW.BIOSIGNAL_TOKENS_HIGH_BR")
            biosignalTokensPriorities.append(2)
            statement2Candidates.append("JOURNAL_VIEW.BIOSIGNAL_INTERP_HIGH_BR")
            statement2Priorities.append(1)
        }
        if (Int(breathingRateResult.minValue.last ?? 0) < 5 || breathingRateResult.getMeanValue() < 8) {
            biosignalTokens.append("JOURNAL_VIEW.BIOSIGNAL_TOKENS_LOW_BR")
            biosignalTokensPriorities.append(1)
        }
        if (Int(breathingRateResult.minValue.last ?? 0) < 5 || breathingRateResult.getMeanValue() < 6.5) {
            biosignalTokens.append("JOURNAL_VIEW.BIOSIGNAL_TOKENS_EXTREME_LOW_BR")
            biosignalTokensPriorities.append(2)
            statement2Candidates.append("JOURNAL_VIEW.BIOSIGNAL_INTERP_EXTREME_LOW_BR")
            statement2Priorities.append(2)
        }
        if (breathingRateResult.getMeanVariability() > 5) {
            biosignalTokens.append("JOURNAL_VIEW.BIOSIGNAL_TOKENS_HIGH_BRV")
            biosignalTokensPriorities.append(2)
            statement2Candidates.append("JOURNAL_VIEW.BIOSIGNAL_INTERP_HIGH_BRV")
            statement2Priorities.append(1)
        }
        if (heartRateResult.getMeanVariability() > 20 && breathingRateResult.getMeanVariability() > 5) {
            biosignalTokens.append("JOURNAL_VIEW.BIOSIGNAL_TOKENS_STRESSED")
            biosignalTokensPriorities.append(2)
            statement2Candidates.append("JOURNAL_VIEW.BIOSIGNAL_INTERP_STRESSED")
            statement2Priorities.append(2)
        }
        if (heartRateResult.getNumberOfZeros() > 5 || breathingRateResult.getNumberOfZeros() > 5) {
            biosignalTokens.append("JOURNAL_VIEW.BIOSIGNAL_TOKENS_MISSING_DATA")
            biosignalTokensPriorities.append(2)
            statement2Candidates.append("JOURNAL_VIEW.BIOSIGNAL_INTERP_MISSING_DATA")
            statement2Priorities.append(2)
        }
        
        // update statements based on conditions and priorities
        let highPriorityIndices = returnMaxPriorityIndex(array: statement2Priorities)
        let mediumPriorityIndices = returnMediumPriorityIndex(array: statement2Priorities)
        if highPriorityIndices.count >= 2 {
            let candidate1 = statement2Candidates[highPriorityIndices[0]]
            let candidate2 = statement2Candidates[highPriorityIndices[1]]
            statement2 = candidate1 + candidate2
        }
        else if highPriorityIndices.count == 1 {
            let candidate1 = statement2Candidates[highPriorityIndices[0]]
            statement2 = candidate1
        }
        else if highPriorityIndices.count == 0 && mediumPriorityIndices.count >= 2 {
            let candidate1 = statement2Candidates[mediumPriorityIndices[0]]
            let candidate2 = statement2Candidates[mediumPriorityIndices[1]]
            statement2 = candidate1 + candidate2
        }
        else if highPriorityIndices.count == 0 && mediumPriorityIndices.count == 1 {
            let candidate1 = statement2Candidates[mediumPriorityIndices[0]]
            statement2 = candidate1
        }
        else {
            statement2 = "JOURNAL_VIEW.BIOSIGNAL_INTERP_NO_ISSUES"
        }
        
        // set statement3 from low priority to high priority
        if ((statement2Candidates.contains("JOURNAL_VIEW.BIOSIGNAL_INTERP_HIGH_HR") || statement2Candidates.contains("JOURNAL_VIEW.BIOSIGNAL_INTERP_HIGH_BR")) && highPriorityIndices.count == 0) {
            statement3 = "JOURNAL_VIEW.BIOSIGNAL_INTERP_EXERCISE_CAN_HELP"
        }
        else if statement2Candidates.contains("JOURNAL_VIEW.BIOSIGNAL_INTERP_MISSING_DATA") && highPriorityIndices.count == 0 {
            statement3 = "JOURNAL_VIEW.BIOSIGNAL_INTERP_ADJUST_SENSOR"
        }
        else if (statement2Candidates.contains("JOURNAL_VIEW.BIOSIGNAL_INTERP_EXTREME_LOW_HR") || statement2Candidates.contains("JOURNAL_VIEW.BIOSIGNAL_INTERP_EXTREME_LOW_BR")) {
            statement3 = "JOURNAL_VIEW.BIOSIGNAL_INTERP_GO_GET_CHECKUP"
        }
        else if (statement2Candidates.contains("JOURNAL_VIEW.BIOSIGNAL_INTERP_STRESSED")) {
            statement3 = "JOURNAL_VIEW.BIOSIGNAL_INTERP_RELAXATION_NEEDED"
        }
        else if (statement2Candidates.contains("JOURNAL_VIEW.BIOSIGNAL_INTERP_NORMAL") && mediumPriorityIndices.count == 0 && highPriorityIndices.count == 0) {
            statement3 = "JOURNAL_VIEW.BIOSIGNAL_INTERP_WE_WILL_LET_YOU_KNOW"
        }
        
        //        print(biosignalTokens)
        let highPriorityIndices2 = returnMaxPriorityIndex(array: biosignalTokensPriorities)
        var outputSummaryTokens: [String] = []
        var count = 0
        for i in highPriorityIndices2 {
            if count < 3 {
                outputSummaryTokens.append(biosignalTokens[i])
            }
            count += 1
        }
        if count < 3 {
            let mediumPrioritiesIndices2 = returnMediumPriorityIndex(array: biosignalTokensPriorities)
            for i in mediumPrioritiesIndices2 {
                if count < 3 {
                    outputSummaryTokens.append(biosignalTokens[i])
                }
                count += 1
            }
        }
        if count < 3 {
            let lowPrioritiesIndices2 = returnLowPriorityIndex(array: biosignalTokensPriorities)
            for i in lowPrioritiesIndices2 {
                if count < 3 {
                    outputSummaryTokens.append(biosignalTokens[i])
                }
                count += 1
            }
        }
        
        //        print(outputSummaryTokens)
        
        if (biosignalTokens.contains("JOURNAL_VIEW.BIOSIGNAL_TOKENS_NORMAL_HR") && biosignalTokens.contains("JOURNAL_VIEW.BIOSIGNAL_TOKENS_NORMAL_BR")) {
            statement2 = "JOURNAL_VIEW.BIOSIGNAL_INTERP_NO_ISSUES"
        }
        if statement3.count == 0 {
            statement3 = "JOURNAL_VIEW.BIOSIGNAL_INTERP_WE_WILL_LET_YOU_KNOW"
        }
        
        return (statement2, statement3, outputSummaryTokens)
    }
    
    
    static func loadFromRealm(date: Date) -> JournalResponse? {
        if let realm = try? Realm() {
            let list = realm.objects(JournalResponseRealm.self).filter { $0.journalDate == date }
            
            if !list.isEmpty {
                let localJournal = list.first!
                
                let heartRateResult = SignalResult(values: Array(localJournal.heartRateResult!.values),
                                                   variability: Array(localJournal.heartRateResult!.variability),
                                                   maxValue: Array(localJournal.heartRateResult!.maxValue),
                                                   minValue: Array(localJournal.heartRateResult!.minValue),
                                                   average: Array(localJournal.heartRateResult!.average)
                )
                
                let breathingRateResult = SignalResult(values: Array(localJournal.breathingRateResult!.values),
                                                       variability: Array(localJournal.breathingRateResult!.variability),
                                                       maxValue: Array(localJournal.breathingRateResult!.maxValue),
                                                       minValue: Array(localJournal.breathingRateResult!.minValue),
                                                       average: Array(localJournal.breathingRateResult!.average)
                )
                
                var temperatureRateResult: SignalResult? = nil
                if let temperature = localJournal.temperature {
                    temperatureRateResult = SignalResult(values: Array(temperature.values),
                                                         variability: Array(temperature.variability),
                                                         maxValue: Array(temperature.maxValue),
                                                         minValue: Array(temperature.minValue),
                                                         average: Array(temperature.average)
                    )
                }
                
                var humidityRateResult: SignalResult? = nil
                if let humidity = localJournal.humidity {
                    humidityRateResult = SignalResult(values: Array(humidity.values),
                                                      variability: Array(humidity.variability),
                                                      maxValue: Array(humidity.maxValue),
                                                      minValue: Array(humidity.minValue),
                                                      average: Array(humidity.average)
                    )
                }
                
                var audioRateResult: SignalResult? = nil
                if let audio = localJournal.audio {
                    audioRateResult = SignalResult(values: Array(audio.values),
                                                   variability: Array(audio.variability),
                                                   maxValue: Array(audio.maxValue),
                                                   minValue: Array(audio.minValue),
                                                   average: Array(audio.average)
                    )
                }
                
//                var bcgRangeRateResult: SignalResult? = nil
//                if let bcgRange = localJournal.bcgRange {
//                    bcgRangeRateResult = SignalResult(values: Array(bcgRange.values),
//                                                      variability: Array(bcgRange.variability),
//                                                      maxValue: Array(bcgRange.maxValue),
//                                                      minValue: Array(bcgRange.minValue),
//                                                      average: Array(bcgRange.average)
//                    )
//                }
                
                
                let stages = localJournal.sleepStageResult?.sleepStages.first?.values ?? RealmSwift.List<Int>()
                
                let sleepStages = SleepStageResult(sleepStart: Array(localJournal.sleepStageResult!.sleepStart),
                                                   sleepEnd: Array(localJournal.sleepStageResult!.sleepEnd),
                                                   sleepDuration: Array(localJournal.sleepStageResult!.sleepDuration), sleepStages: [
                                                    Array(stages)])
                
                let bioRecommendations = Array(localJournal.biosignalRecommendations).compactMap({ Recommendation(priority: $0.priority, recommendation: $0.recommendation, token: $0.token) })
                
                let sleepRecommendations = Array(localJournal.sleepRecommendations).compactMap({ Recommendation(priority: $0.priority, recommendation: $0.recommendation, token: $0.token) })
                
                let radarRecommendations = Array(localJournal.radarRecommendations).compactMap({ Recommendation(priority: $0.priority, recommendation: $0.recommendation, token: $0.token) })
                
                let localJournalToSet = JournalResponse(hasPremium: localJournal.hasPremium,
                                                        journalDate: localJournal.journalDate.toISODate(),
                                                        sleepQuality: localJournal.sleepQuality,
                                                        sleepEfficiency: localJournal.sleepEfficiency,
                                                        lightDuration: localJournal.lightDuration,
                                                        deepDuration: localJournal.deepDuration,
                                                        remDuration: localJournal.remDuration,
                                                        wokenDuration: localJournal.wokenDuration,
                                                        heartRateResult: heartRateResult,
                                                        breathingRateResult: breathingRateResult,
                                                        sleepStageResult: sleepStages,
                                                        radarValues: Array(localJournal.radarValues),
                                                        xAxisSteps: Array(localJournal.xAxisSteps),
                                                        dates: Array(localJournal.dates),
                                                        //                                                        alarmOnTime: localJournal.alarmOnTime,
                                                        //                                                        targetTime: localJournal.targetTime,
                                                        //                                                        timerDifference: localJournal.timerDifference,
                                                        wakeUpState: localJournal.wakeUpState,
                                                        biosignalRecommendations: bioRecommendations,
                                                        sleepRecommendations: sleepRecommendations,
                                                        radarRecommendations: radarRecommendations,
                                                        temperatureResult: temperatureRateResult,
                                                        humidityResult: humidityRateResult,
                                                        audioResult: audioRateResult
//                                                        bcgRangeResult: bcgRangeRateResult
                                                        
                )
                print("Realm: loaded journal \(date)!")
                return localJournalToSet
            } else {
                return nil
            }
            
        } else {
            deleteFiles(urlsToDelete: getRealmDocs())
            return nil
        }
    }
    
    static func saveToRealm(journal: JournalResponse, date: Date) {
        let journalResponseLocal = JournalResponseRealm()
        
        journalResponseLocal.hasPremium = journal.hasPremium
        //        journalResponseLocal.alarmOnTime = journal.alarmOnTime
        //        journalResponseLocal.targetTime = journal.targetTime
        //        journalResponseLocal.timerDifference = journal.timerDifference
        journalResponseLocal.wakeUpState = journal.wakeUpState
        journalResponseLocal.journalDate = date
        journalResponseLocal.sleepQuality = journal.sleepQuality
        journalResponseLocal.sleepEfficiency = journal.sleepEfficiency
        journalResponseLocal.lightDuration = journal.lightDuration
        journalResponseLocal.deepDuration = journal.deepDuration
        journalResponseLocal.remDuration = journal.remDuration
        journalResponseLocal.wokenDuration = journal.wokenDuration
        journalResponseLocal.radarValues.append(objectsIn: journal.radarValues)
        journalResponseLocal.xAxisSteps.append(objectsIn: journal.xAxisSteps)
        journalResponseLocal.dates.append(objectsIn: journal.dates)
        
        let heartRateResult = SignalResultRealm()
        heartRateResult.maxValue.append(objectsIn: journal.heartRateResult.maxValue)
        heartRateResult.minValue.append(objectsIn: journal.heartRateResult.minValue)
        heartRateResult.values.append(objectsIn: journal.heartRateResult.values)
        heartRateResult.variability.append(objectsIn: journal.heartRateResult.variability)
        heartRateResult.average.append(objectsIn: journal.heartRateResult.average)
        
        let breathRateResult = SignalResultRealm()
        breathRateResult.maxValue.append(objectsIn: journal.breathingRateResult.maxValue)
        breathRateResult.minValue.append(objectsIn: journal.breathingRateResult.minValue)
        breathRateResult.values.append(objectsIn: journal.breathingRateResult.values)
        breathRateResult.variability.append(objectsIn: journal.breathingRateResult.variability)
        breathRateResult.average.append(objectsIn: journal.breathingRateResult.average)
        
        if let temperature = journal.temperatureResult {
            let temperatureResult = SignalResultRealm()
            temperatureResult.maxValue.append(objectsIn: temperature.maxValue)
            temperatureResult.minValue.append(objectsIn: temperature.minValue)
            temperatureResult.values.append(objectsIn: temperature.values)
            temperatureResult.variability.append(objectsIn: temperature.variability)
            temperatureResult.average.append(objectsIn: temperature.average)
            journalResponseLocal.temperature = temperatureResult
        }
        
        if let humidity = journal.humidityResult {
            let humidityResult = SignalResultRealm()
            humidityResult.maxValue.append(objectsIn: humidity.maxValue)
            humidityResult.minValue.append(objectsIn: humidity.minValue)
            humidityResult.values.append(objectsIn: humidity.values)
            humidityResult.variability.append(objectsIn: humidity.variability)
            humidityResult.average.append(objectsIn: humidity.average)
            journalResponseLocal.humidity = humidityResult
        }
        
        if let audio = journal.audioResult {
            let audioResult = SignalResultRealm()
            audioResult.maxValue.append(objectsIn: audio.maxValue)
            audioResult.minValue.append(objectsIn: audio.minValue)
            audioResult.values.append(objectsIn: audio.values)
            audioResult.variability.append(objectsIn: audio.variability)
            audioResult.average.append(objectsIn: audio.average)
            journalResponseLocal.audio = audioResult
        }
        
//        if let bcgRange = journal.bcgRangeResult {
//            let bcgRangeResult = SignalResultRealm()
//            bcgRangeResult.maxValue.append(objectsIn: bcgRange.maxValue)
//            bcgRangeResult.minValue.append(objectsIn: bcgRange.minValue)
//            bcgRangeResult.values.append(objectsIn: bcgRange.values)
//            bcgRangeResult.variability.append(objectsIn: bcgRange.variability)
//            bcgRangeResult.average.append(objectsIn: bcgRange.average)
//            journalResponseLocal.bcgRange = bcgRangeResult
//        }
        
        journalResponseLocal.breathingRateResult = breathRateResult
        journalResponseLocal.heartRateResult = heartRateResult
        
        let sleepStages = SleepStagesRealm()
        sleepStages.values.append(objectsIn: journal.sleepStageResult.sleepStages[0])
        
        let sleepStagesResult = SleepStageResultRealm()
        sleepStagesResult.sleepStart.append(objectsIn: journal.sleepStageResult.sleepStart)
        sleepStagesResult.sleepEnd.append(objectsIn: journal.sleepStageResult.sleepEnd)
        sleepStagesResult.sleepDuration.append(objectsIn: journal.sleepStageResult.sleepDuration)
        sleepStagesResult.sleepStages.append(sleepStages)
        
        journalResponseLocal.sleepStageResult = sleepStagesResult
        
        journalResponseLocal.biosignalRecommendations.append(objectsIn: journal.biosignalRecommendations.compactMap{ RecommendationRealm(priority: $0.priority, recommendation: $0.recommendation, token: $0.token) })
        journalResponseLocal.sleepRecommendations.append(objectsIn: journal.sleepRecommendations.compactMap{ RecommendationRealm(priority: $0.priority, recommendation: $0.recommendation, token: $0.token) })
        journalResponseLocal.radarRecommendations.append(objectsIn: journal.radarRecommendations.compactMap{ RecommendationRealm(priority: $0.priority, recommendation: $0.recommendation, token: $0.token) })
        
        if let realm = try? Realm() {
            try! realm.write {
                realm.add(
                    journalResponseLocal
                )
                print("Realm: journal \(date) successfully saved!")
            }
        } else {
            deleteFiles(urlsToDelete: getRealmDocs())
        }
    }
}

struct QueryJournalDataResponse: Codable {
    var data: JournalResponse
}

enum Status: String {
    case GOOD
    case NORMAL
    case BAD
    case UNKNOWN
    case BIO
}

extension Double {
    func toHour() -> Int {
        return Int(self.plusOffset()/60)
    }
}
