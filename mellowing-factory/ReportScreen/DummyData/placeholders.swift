//
//  placeholders.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/07/31.
//

import Foundation

let weeklyEmptyStat = StatisticsResponse(id: "empty", created: "2022-07-04T06:39:19.661Z",
                                                      sleepStages: weeklyEmptySleepStages,
                                                      radarValues: dummyRadarResult,
                                                      heartRate: weeklyEmptyBio,
                                                      breathingRate: weeklyEmptyBio,
                                                      sleepQuality: [0,0,0,0,0,0,0],
                                                      sleepLatency: [0,0,0,0,0,0,0],
                                                      lightDuration: [0,0,0,0,0,0,0],
                                                      sleepEfficiency: [0,0,0,0,0,0,0],
                                                      deepDuration: [0,0,0,0,0,0,0],
                                                      remDuration: [0,0,0,0,0,0,0],
                                                      wokenDuration: [0,0,0,0,0,0,0],
                                                      wakeUpState: [0,0,0,0,0,0,0],
                                                      updated: "2023-01-31T07:32:33.654Z",
                                                      percentageChangeRadar: [0,0,0,0,0],
                                                      sleepDebt: [0,0,0,0,0,0,0],
                                                      temperature: weeklyEmptyBio,
                                                      humidity: weeklyEmptyBio,
                                                      audio: weeklyEmptyBio
)

let weeklyEmptySleepStages =  SleepStageResult(
    sleepStart: [0, 0, 0, 0, 0, 0, 0],
    sleepEnd: [0, 0, 0, 0, 0, 0, 0],
    sleepDuration: [0, 0, 0, 0, 0, 0, 0],
    sleepStages: [ [0], [0], [0], [0], [0], [0], [0]]
)

let weeklyEmptyBio = SignalResult(
    values: [0,0,0,0,0,0,0],
    variability: [0,0,0,0,0,0,0],
    maxValue: [0,0,0,0,0,0,0],
    minValue: [0,0,0,0,0,0,0],
    average: [0,0,0,0,0,0,0]
)

func createYearlyEmptyStat(date: Date) -> StatisticsResponse {
    return StatisticsResponse(
        id: "empty",
        created: date.toStringUTC(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"),
                                             sleepStages: yearlyEmptySleepStages,
                                             radarValues: yearlyEmptyRadar,
                                             heartRate: yearlyEmptyBio,
                                             breathingRate: yearlyEmptyBio,
                                             sleepQuality: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                             sleepLatency: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                             lightDuration: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                             sleepEfficiency: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                             deepDuration: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                             remDuration: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                             wokenDuration: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                             wakeUpState: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                             updated: date.toStringUTC(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"),
                                             percentageChangeRadar: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                             sleepDebt: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                             temperature: yearlyEmptyBio,
                                             humidity: yearlyEmptyBio,
                                             audio: yearlyEmptyBio
    )
}

var yearlyEmptyStat = StatisticsResponse(id: "empty",
                                         created: "2022-07-04T06:39:19.661Z",
                                         sleepStages: yearlyEmptySleepStages,
                                         radarValues: yearlyEmptyRadar,
                                         heartRate: yearlyEmptyBio,
                                         breathingRate: yearlyEmptyBio,
                                         sleepQuality: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                         sleepLatency: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                         lightDuration: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                         sleepEfficiency: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                         deepDuration: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                         remDuration: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                         wokenDuration: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                         wakeUpState: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                         updated: "2023-01-31T07:32:33.654Z",
                                         percentageChangeRadar: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                         sleepDebt: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
                                         temperature: yearlyEmptyBio,
                                         humidity: yearlyEmptyBio,
                                         audio: yearlyEmptyBio
)

let yearlyEmptySleepStages =  SleepStageResult(
    sleepStart: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
    sleepEnd: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
    sleepDuration: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
    sleepStages: [ [0], [0], [0], [0], [0], [0], [0],[0], [0], [0], [0], [0]]
)

let yearlyEmptyBio = SignalResult(
    values: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
    variability: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
    maxValue: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
    minValue: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0],
    average: [0, 0, 0, 0, 0, 0, 0,0,0,0,0,0]
)

let yearlyEmptyRadar: [[Double]] = [
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

let audioPlaceholder = SignalResult(
    values: [0,0,0,0,0,0,0],
    variability: [0,0,0,0,0,0,0],
    maxValue: [0,0,0,0,0,0,0],
    minValue: [0,0,0,0,0,0,0],
    average: [0,0,0,0,0,0,0]
)

let humidityPlaceholder = SignalResult(
    values: [0,0,0,0,0,0,0],
    variability: [0,0,0,0,0,0,0],
    maxValue: [0,0,0,0,0,0,0],
    minValue: [0,0,0,0,0,0,0],
    average: [0,0,0,0,0,0,0])

let temperaturePlaceholder = SignalResult(
    values: [0,0,0,0,0,0,0],
    variability: [0,0,0,0,0,0,0],
    maxValue: [0,0,0,0,0,0,0],
    minValue: [0,0,0,0,0,0,0],
    average: [0,0,0,0,0,0,0])

let yAxisPlaceholder = ["13h", "11h", " 9h", " 7h", " 5h", " 3h", " 1h"]
let yAxisPlaceholderS = ["10", "8", "6", "4", "2", "00", "10"]
