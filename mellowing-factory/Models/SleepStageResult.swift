//
//  SleepStageResult.swift
//  mellowing-factory
//
//  Created by Florian Topf on 02.10.21.
//

import SwiftUI

struct SleepStageResult: Codable {
    let sleepStart: [Double] // minutes (day 1)
    let sleepEnd: [Double] // sleep end in minutes (day 1 or day 2)
    let sleepDuration: [Int] // minutes
    let sleepStages: [[Int]]  // 0 = awake, 1 = REM, 2 = (light) sleep, 3 = deep sleep
    
    // TODO: do this without force unwrapping - do we need this? can we just not perform this function if data is not available?
    // TODO: these values are used multiple times, can we calculate once and store in a variable?
    func getMinSleepStartHour() -> Double {
        
        guard !sleepStart.isEmpty else { return 0 }
        
        let sleepStartPlusOffset = sleepStart
            .filter({ $0 > 0 })
            .map({ $0.plusOffset() })
        
        let filtered = sleepStartPlusOffset
            .filter({ $0 >= 720 })
        let minSleepStart = filtered.isEmpty ? sleepStartPlusOffset.min()! : filtered.min()!
        
//        let minSleepStart = sleepStartPlusOffset.min()!
        
        let barStartPoint = minSleepStart - minSleepStart.truncatingRemainder(dividingBy: 60)
        
//        print("🍔")
//        print(sleepStart)
//        print(sleepStartPlusOffset)
//        print(barStartPoint)
        
        return barStartPoint
    }
    
    func getMaxSleepEndHour() -> Double {
        let shiftedSleepEnd = sleepEnd
            .filter({ $0 > 0 })
            .map({ $0.plusOffset() })

        var maxSleepEnd = shiftedSleepEnd
            .map{ ($0 < 720) && shiftedSleepEnd.allSatisfy({ $0 < 720 }) ? $0 + 1440 : $0 }
            .max() ?? 0
        
        if maxSleepEnd > 1440 {
            maxSleepEnd -= 1440
        }

        if maxSleepEnd + 60 < 1440 {
            maxSleepEnd = maxSleepEnd + 60
        }
        
        let maxSleepEndHour = maxSleepEnd + maxSleepEnd.truncatingRemainder(dividingBy: 60)
        
//        print("🍔")
//        print("sleepDuration: \(sleepDuration)")
//        print("sleepEnd: \(sleepEnd)")
//        print(shiftedSleepEnd)
//        print(maxSleepEnd)
//        print(maxSleepEndHour)
        
        return maxSleepEndHour
    }
    
    func getPlotRangeInMinutes() -> Double {
        var plotRange: Double = 0
        if getMaxSleepEndHour() < getMinSleepStartHour() {
            plotRange = (getMaxSleepEndHour() + 1440) - getMinSleepStartHour()
        } else {
            plotRange = getMaxSleepEndHour() - getMinSleepStartHour()
        }
        
        return plotRange
        
    }
    
    // get yAxisLabels in HH:MM format
    func getStatisticsYAxisSteps() -> [String] {
        // TODO: check this! (this division needs to be dynamic and change with the data)
        let division = 6.0
//        if getPlotRangeInMinutes().truncatingRemainder(dividingBy: 120) == 60 {
//            division = 8.0
//        }
        let step = getPlotRangeInMinutes() / division
//        let max  = getMaxSleepEndHour() + 1440
        let max  = getPlotRangeInMinutes() > getMaxSleepEndHour() ? getMaxSleepEndHour() + 1440 : getMaxSleepEndHour()
        var yAxisSteps: [String] = []
        if getPlotRangeInMinutes() > 0 {
            let strider = stride(from: getMinSleepStartHour(), through: max, by: step)
            for yAxisValue in strider {
                if yAxisValue > 1440 {
                    yAxisSteps.append((yAxisValue - 1440).asTimeString(style: .positional))
                } else {
                    yAxisSteps.append(yAxisValue.asTimeString(style: .positional))
                }
            }
        }
//        print(getMaxSleepEndHour())
//        print(getMinSleepStartHour())
//        print(yAxisSteps)
        return yAxisSteps.reversed()
    }
    
    func getBarsYAxisOffsets() -> [Double] {
        
        
        let sleepStartPlusOffset = sleepStart
            .map({ $0.plusOffset() })
        
        
        let minSleepStart = sleepStartPlusOffset
            .filter({ $0 >= 0 })
            .filter({ !sleepStartPlusOffset.allSatisfy({ $0 < 720 }) ? $0 > 720 : $0 >= 0 })
            .min() ?? 0
        
            let yAxisOffset = minSleepStart.truncatingRemainder(dividingBy: 60)
        
        
        let sleepStartWithYAxisOffset = sleepStartPlusOffset.map{ $0+yAxisOffset-minSleepStart + (($0 <= 720) && !sleepStartPlusOffset.allSatisfy({ $0 < 720 }) ? 1440 : 0) }
        
        
//        print("🍔")
//        print(minSleepStart)
//        print(sleepStart)
//        print(sleepStart.map({ $0.plusOffset() }))
//        print(yAxisOffset)
//        print(sleepStartWithYAxisOffset)
        
        return sleepStartWithYAxisOffset
    }

    // yAxisSteps in JOURNAL VIEW
    func getHypnogramYAxisSteps() -> [String] {
        return ["JOURNAL.AWAKE", "JOURNAL.REM", "SLEEP", "JOURNAL.DEEP_SLEEP"]
    }
    
    func getAverageSleepEnd() -> Double {
        let sleepEndWithoutZerosPlusOffset = sleepEnd.filter{ $0 > 0 }.map { $0.plusOffset() }
        let total = sleepEndWithoutZerosPlusOffset.map { $0 > 720 ? $0 - 1440 : $0 }.reduce(0, +)
        var average = abs(total / Double(sleepEndWithoutZerosPlusOffset.count))
        if average > 1440 {
            average = average - 1440
        }
        return average
    }
    
    func getAverageSleepStart() -> Double {
        let sleepStartWithoutZerosPlusOffset = sleepStart.filter{ $0 > 0 }.map { $0.plusOffset() }
        let total = sleepStartWithoutZerosPlusOffset.map { $0 < 720 ? $0 + 1440 : $0 }.reduce(0, +)
        var average = abs(total / Double(sleepStartWithoutZerosPlusOffset.count))
        if average > 1440 {
            average = average - 1440
        }
        return average
    }
    
    func getAverageSleepDuration() -> Int {
        let total = sleepDuration.filter{ $0 > 0 }.reduce(0, +)
        return total > 0 ? total / sleepDuration.filter{ $0 > 0 }.count : 0
    }
}
