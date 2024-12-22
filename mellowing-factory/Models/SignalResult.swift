//
// HeartRateResult.swift
// mellowing-factory
//
// Created by Florian Topf on 13.10.21.
//
import Foundation

struct SignalResult: Codable {
    //  let hasStress: [Bool]
    let values: [Double]
    let variability: [Double]
    let maxValue: [Double]
    let minValue: [Double]
    let average: [Double]
    // if values are empty, there is no data, show 'NO DATA FOR THESE DAYS' result
    
    func getMeanValue() -> Double {
        guard !values.isEmpty else { return 0 }
        let filteredValues = values.filter({ $0 > 0 })
        let sum = filteredValues.reduce(0, {a, b in return a+b})
        let mean = Double(sum)/Double(filteredValues.count)
        return Double(round(10 * mean) / 10)
    }
    
    func getMeanVariability() -> Double {
        let filteredValues = variability.filter({ $0 > 0 })
        let sum = filteredValues.reduce(0, {a, b in return a+b})
        let mean = Double(sum)/Double(filteredValues.count)
        return Double(mean)
    }
    
    func getNumberOfZeros() -> Int {
        let filteredValues = values.filter({ $0 == 0 })
        return filteredValues.count
    }
    
    // can work with both journal view (JournalResponse) and statistics view (StatisticsResponse)
    // for journal view minValue.count = 1, week view minValue.count=7, etc..
    func getRoundedMinBiosignalValue(interval: Double) -> Double {
        // cases for journal view
        if variability.count > 0 {
            let lowerStandardDeviationValue = zip(values, variability).map { $0 - $1 }
            // TODO: this may cause the lengths of the breathrate and heartrate to be unequal when there are missing values at the ends making the graphs different widths
            if let minValue = lowerStandardDeviationValue.filter({ $0 > 0 }).min() {
                let minValueRounded = minValue - minValue.truncatingRemainder(dividingBy: interval)
                return minValueRounded
            }
        }
        // cases for statistics view
        else {
            if let minValue = minValue.filter({ $0 > 0 }).min() {
                return minValue - interval * 2
//                let minValueRounded = minValue - minValue.truncatingRemainder(dividingBy: interval)
//                return minValueRounded
            }
        }
        return 0
    }
    func getRoundedMaxBiosignalValue(interval: Double) -> Double {
        if variability.count > 0 {
            let upperStandardDeviationValue = zip(values, variability).map { $0 + $1 }
            if let maxValue = upperStandardDeviationValue.max() {
                var maxValueRounded = maxValue + interval - (maxValue+interval).truncatingRemainder(dividingBy: interval)
                // TODO: this is a quick fix, need to change UI dynamically
                if maxValueRounded < getRoundedMinBiosignalValue(interval: interval) + 6*interval {
                    maxValueRounded = getRoundedMinBiosignalValue(interval: interval) + 6*interval
                }
                else if (maxValueRounded > getRoundedMinBiosignalValue(interval: interval) + 6*interval && maxValueRounded < getRoundedMinBiosignalValue(interval: interval) + 12*interval) {
                    maxValueRounded = getRoundedMinBiosignalValue(interval: interval) + 12*interval
                }
                return maxValueRounded
            }
        }
        else {
            if let maxValue = maxValue.max() {
                return maxValue + interval
//                var maxValueRounded = maxValue + interval - (maxValue+interval).truncatingRemainder(dividingBy: interval)
//                // TODO: this is a quick fix, need to change UI dynamically
//                if maxValueRounded < getRoundedMinBiosignalValue(interval: interval) + 6*interval {
//                    maxValueRounded = getRoundedMinBiosignalValue(interval: interval) + 6*interval
//                }
//                else if (maxValueRounded > getRoundedMinBiosignalValue(interval: interval) + 6*interval && maxValueRounded < getRoundedMinBiosignalValue(interval: interval) + 12*interval) {
//                    maxValueRounded = getRoundedMinBiosignalValue(interval: interval) + 12*interval
//                }
//                return maxValueRounded
            }
        }
        return 0
    }
    // this interval should be 10 or 20 for HR, and 3 or 5 for BR
    func getBiosignalPlotRange(interval: Double) -> Double {
        return getRoundedMaxBiosignalValue(interval: interval) - getRoundedMinBiosignalValue(interval: interval)
    }
    func getBiosignalYAxisSteps(interval: Double) -> [String] {
        // TODO: check this! (this division may need to be dynamic and change with the data)
//        let division = getBiosignalPlotRange(interval: interval) / interval
        // if this changes dynamically, the UI needs to be changing dynamically
        let division = 5.0
        
        let step = getBiosignalPlotRange(interval: interval) / division
//        print(step)
        var yAxisSteps: [String] = []
        if getBiosignalPlotRange(interval: interval) > 0 {
            let strider = stride(from: getRoundedMinBiosignalValue(interval: interval), through: getRoundedMaxBiosignalValue(interval: interval), by: step).map{Double($0).removeZerosFromEnd()}
            for yAxisValue in strider {
                yAxisSteps.append(yAxisValue)
            }
        }
//        print(yAxisSteps)
        return yAxisSteps.reversed()
    }
    
    // function needed for getChartValues
    func getMinValueAndYAxisOffsets(interval: Double) -> (minVal: Double, yOffset: Double) {
        let minValue = minValue.filter{ $0 > 0 }.min()
        let yAxisOffset = minValue! - minValue!.truncatingRemainder(dividingBy: interval)
        return (minValue!, yAxisOffset)
    }
    // function to produce values between 0-1 with offset, also produces min, max, and std values: for journal view only use chartValues/chartSTDs; for statistis view, use chartValues/chartMax/chartMin
    func getChartValues(interval: Double) -> ([Double], [Double], [Double], [Double], [Double]) {
        
        let result = getMinValueAndYAxisOffsets(interval: interval)
        let minVal = result.minVal
        let yOffset = result.yOffset
        
        // should be availble for both StatisticsResponse and JournalResponse
        let valuesWithYAxisOffset = values.map{$0+yOffset-minVal}
        let intermittentValues = valuesWithYAxisOffset.map{$0-getRoundedMinBiosignalValue(interval: interval)}
        let chartValues = intermittentValues.map{$0/getBiosignalPlotRange(interval: interval)}
        
        // should return empty array for StasticsResponse
        let upperSTDValues = zip(values, variability).map { $0 + $1 }
        let upperSTDWithYAxisOffset = upperSTDValues.map{$0+yOffset-minVal}
        let intermittentUpper = upperSTDWithYAxisOffset.map{$0-getRoundedMinBiosignalValue(interval: interval)}
        let chartUpper = intermittentUpper.map{$0/getBiosignalPlotRange(interval: interval)}
        let lowerSTDValues = zip(values, variability).map { $0 - $1 }
        let lowerSTDWithYAxisOffset = lowerSTDValues.map{$0+yOffset-minVal}
        let intermittentLower = lowerSTDWithYAxisOffset.map{$0-getRoundedMinBiosignalValue(interval: interval)}
        let chartLower = intermittentLower.map{$0/getBiosignalPlotRange(interval: interval)}
        
        // should return empty array (or array of 1??) for JournalResponse
        let maxWithYAxisOffset = maxValue.map{$0+yOffset-minVal}
        let intermittentMax = maxWithYAxisOffset.map{$0-getRoundedMinBiosignalValue(interval: interval)}
        let chartMax = intermittentMax.map{$0/getBiosignalPlotRange(interval: interval)}
        let minWithYAxisOffset = minValue.map{$0+yOffset-minVal}
        let intermittentMin = minWithYAxisOffset.map{$0-getRoundedMinBiosignalValue(interval: interval)}
        let chartMin = intermittentMin.map{$0/getBiosignalPlotRange(interval: interval)}
        
        return (chartValues, chartLower, chartUpper, chartMin, chartMax)
    }
    
//    func getChartValues2(interval: Double, numberOfhours: Int) -> ([Double], [Double], [Double]) {
//        // MARK: need to filter out chartValues < 0 (occurs due to NaNs passed as 0's by the backend)
//        let chartValues = values.map { ($0 - getRoundedMinBiosignalValue(interval: interval)) / getBiosignalPlotRange(interval: interval) }
//        let minChartValues = minValue.map { ($0 - getRoundedMinBiosignalValue(interval: interval)) / getBiosignalPlotRange(interval: interval)  }
//        let maxChartValues = maxValue.map { ($0 - getRoundedMinBiosignalValue(interval: interval)) / getBiosignalPlotRange(interval: interval)  }
//        let maxVariabilities = zip(values,variability).map() {$0 + $1}
//        let chartMaxVariabilities = maxVariabilities.map { ($0 - getRoundedMinBiosignalValue(interval: interval)) / getBiosignalPlotRange(interval: interval)  }
//        let minVariabilities = zip(values,variability).map() {$0 - $1}
//        let chartMinVariabilities = minVariabilities.map { ($0 - getRoundedMinBiosignalValue(interval: interval)) / getBiosignalPlotRange(interval: interval)  }
//
//        return (chartValues, minChartValues, maxChartValues)
//    }
    
    func getMaxMinWeekly(numberOfhours: Int) -> ([Double], [Double]) {
        guard !values.isEmpty else { return ([], []) }
        guard !variability.isEmpty else { return ([], []) }
        
        var maxArray: [Double] = []
        var minArray: [Double] = []
        for i in 0..<values.count {
            //                if values[i] > 0 && variability[i] > 0 {
            maxArray.append(values[i] + variability[i])
            minArray.append(values[i] - variability[i])
            //                }
        }

        return (minArray.reversed(), maxArray.reversed())
//        return (minArray, maxArray)
    }
}
