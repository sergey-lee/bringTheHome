//
//  dummyYear.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/06.
//

import Foundation

let testerYearly2022 = StatisticsResponse(id: "dummy",
                                          created: "2022-07-04T06:39:19.661Z",
                                          sleepStages: dummySleepStageResultYearly,
                                          radarValues: testerRadarResultYearly2022,
                                          heartRate: dummyBioSignalResultHeartRateYearly,
                                          breathingRate: dummyBioSignalResultBreathingRateYearly,
                                          sleepQuality: [70,95,90,85,75,0,95,100,95,90,80,86],
                                          sleepLatency: [7,18,5,6,15,0,19,7,18,5,6,15],
                                          lightDuration: [67,60,74,83,86,0,75,67,60,74,83,86],
                                          sleepEfficiency: [96,97,98,97,97,0,97,96,97,98,97,97],
                                          deepDuration: [67,60,74,83,86,0,75,67,60,74,83,86],
                                          remDuration: [89,87,95,80,99,0,90,89,87,95,80,99],
                                          wokenDuration: [89,87,95,80,99,0,90,89,87,95,80,99],
                                          wakeUpState: [0,0,0,0,0,0,0,0,0,0,0,0],
                                          updated: "--",
                                          percentageChangeRadar: [-12, 36, 32, 19, -10],
                                          sleepDebt: [138,-105,-96,-95,0,153,-82],
                                          temperature: dummytemperatureYearly,
                                          humidity: dummyhumidityYearly,
                                          audio: dummyaudioYearly
)

let testerYearly2023 = StatisticsResponse(id: "dummy",
                                          created: "2023-07-04T06:39:19.661Z",
                                          sleepStages: dummySleepStageResultYearly,
                                          radarValues: testerRadarResultYearly2023ForCurrentMonth,
                                          heartRate: dummyBioSignalResultHeartRateYearly,
                                          breathingRate: dummyBioSignalResultBreathingRateYearly,
                                          sleepQuality: [70,95,90,85,75,0,95,100,95,90,80,86],
                                          sleepLatency: [7,18,5,6,15,0,19,7,18,5,6,15],
                                          lightDuration: [67,60,74,83,86,0,75,67,60,74,83,86],
                                          sleepEfficiency: [96,97,98,97,97,0,97,96,97,98,97,97],
                                          deepDuration: [67,60,74,83,86,0,75,67,60,74,83,86],
                                          remDuration: [89,87,95,80,99,0,90,89,87,95,80,99],
                                          wokenDuration: [89,87,95,80,99,0,90,89,87,95,80,99],
                                          wakeUpState: [0,0,0,0,0,0,0,0,0,0,0,0],
                                          updated: "--",
                                          percentageChangeRadar: [-12, 36, 32, 19, -10],
                                          sleepDebt: [138,-105,-96,-95,0,153,-82],
                                          temperature: dummytemperatureYearly,
                                          humidity: dummyhumidityYearly,
                                          audio: dummyaudioYearly
)

let yearlyPlaceholder = StatisticsResponse(id: "dummy",
                                           created: "2022-07-04T06:39:19.661Z",
                                           sleepStages: dummySleepStageResultYearly,
                                           radarValues: dummyRadarResultYearly,
                                           heartRate: dummyBioSignalResultHeartRateYearly,
                                           breathingRate: dummyBioSignalResultBreathingRateYearly,
                                           sleepQuality: [0,0,0,0,0,0,0,0,0,0,0,0],
                                           sleepLatency: [7,18,5,6,15,0,19,7,18,5,6,15],
                                           lightDuration: [67,60,74,83,86,0,75,67,60,74,83,86],
                                           sleepEfficiency: [96,97,98,97,97,0,97,96,97,98,97,97],
                                           deepDuration: [67,60,74,83,86,0,75,67,60,74,83,86],
                                           remDuration: [89,87,95,80,99,0,90,89,87,95,80,99],
                                           wokenDuration: [89,87,95,80,99,0,90,89,87,95,80,99],
                                           wakeUpState: [0,0,0,0,0,0,0,0,0,0,0,0],
                                           updated: "--",
                                           percentageChangeRadar: [-12, 36, 32, 19, -10],
                                           sleepDebt: [138,-105,-96,-95,0,153,-82],
                                           temperature: dummytemperatureYearly,
                                           humidity: dummyhumidityYearly,
                                           audio: dummyaudioYearly
)

let dummyBioSignalResultHeartRateYearly = SignalResult(
    values: [16, 11, 10, 9, 8, 0, 5, 16, 11, 10, 9, 8],
    variability: [2.5, 2.1, 1.8, 1.6, 1.7, 0, 1.9, 2.5, 2.1, 1.8, 1.6, 1.7],
    maxValue: [16, 12, 13, 12, 11, 0, 10, 16, 12, 13, 12, 11],
    minValue: [8, 7, 7, 5, 7, 0, 4, 8, 7, 7, 5, 7],
    average: [16, 11, 10, 9, 8, 0, 5, 16, 11, 10, 9, 8]
)


let dummyBioSignalResultBreathingRateYearly = SignalResult(
    values: [16, 11, 10, 9, 8, 0, 5, 16, 11, 10, 9, 8],
    variability: [2.5, 2.1, 1.8, 1.6, 1.7, 0, 1.9, 2.5, 2.1, 1.8, 1.6, 1.7],
    maxValue: [16, 12, 13, 12, 11, 0, 10, 16, 12, 13, 12, 11],
    minValue: [8, 7, 7, 5, 7, 0, 4, 8, 7, 7, 5, 7],
    average: [16, 11, 10, 9, 8, 0, 5, 16, 11, 10, 9, 8]
)

let dummytemperatureYearly = SignalResult(
    values: [81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9],
    variability: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    maxValue: [81.9],
    minValue: [81.9],
    average: [81.9]
)

let dummyhumidityYearly = SignalResult(
    values: [81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9],
    variability: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    maxValue: [81.9],
    minValue: [81.9],
    average: [81.9]
)

let dummyaudioYearly = SignalResult(
    values: [81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9, 81.9],
    variability: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    maxValue: [81.9],
    minValue: [81.9],
    average: [81.9]
)

let dummySleepStageResultYearly = SleepStageResult(sleepStart: [1342,1424,1394,1307,1395,0,1434,1342,1424,1394,1307,1395],
                                                   sleepEnd: [376,461,439,343,434,0,475,376,461,439,343,434],
                                                   sleepDuration: [474,477,485,476,479,0,481,474,477,485,476,479],
                                                   sleepStages: [ dummy1, dummy2, dummy3, dummy4, dummy5, dummy6, dummy7, dummy1, dummy2, dummy3, dummy4, dummy5])

let dummyRadarResultYearly: [[Double]] = [
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0]
]

let testerRadarResultYearly2022: [[Double]] = [
    [89,87,95,80,99],
    [76,57,68,97,97],
    [66,87,48,67,37],
    [46,77,98,97,57],
    [56,97,98,67,97],
    [0,0,0,0,0],
    [66,87,48,67,37],
    [46,77,98,97,57],
    [56,97,98,67,97],
    [96,97,98,97,90],
    [89,87,95,80,99],
    [76,57,68,97,97],
]

let testerRadarResultYearly2023: [[Double]] = [
    [89,87,95,80,99],
    [76,57,68,97,97],
    [76,57,68,97,97],
    [46,77,98,97,57],
    [56,97,98,67,97],
    [89,87,95,80,99],
    [76,57,68,97,97],
    [66,87,48,67,37],
    [46,77,98,97,57],
    [56,97,98,67,97],
    [76,57,68,97,97],
    [66,87,48,67,37],
]

//MARK: Getting count of months until current month
let testerRadarResultYearly2023ForCurrentMonth: [[Double]] = {
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.month], from: Date())
    let month = dateComponents.month!
    
    var radars: [[Double]] = []
    
    for i in 0..<month {
        radars.append(testerRadarResultYearly2023[i])
    }

    for i in month..<12 {
        radars.append([0,0,0,0,0])
    }

    return radars
}()

let dummyYearlyaudio = SignalResult(
    values: [7, 7, 8, 9, 9, 13, 12, 11, 7, 7, 8, 9, 9],
    variability: [1, 2, 3, 3, 4, 4, 2, 1, 2, 3, 3, 4],
    maxValue: [17],
    minValue: [8],
    average: [12]
)

let dummyYearlyhumidity = SignalResult(
    values: [35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35],
    variability: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    maxValue: [40],
    minValue: [32],
    average: [36])

let dummyYearlytemperature = SignalResult(
    values: [26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26],
    variability: [1, 1, 1, 1, 1, 1],
    maxValue: [26],
    minValue: [12],
    average: [19])
