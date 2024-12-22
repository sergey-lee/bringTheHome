//
//  dummyJournalData.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/20.
//

import SwiftUI

let journalPlaceholder = JournalResponse(hasPremium: true,
                                       journalDate: "2022-07-19T15:00:00Z",
                                       sleepQuality: 0,
                                       sleepEfficiency: 90,
                                       lightDuration: 120,
                                       deepDuration: 48,
                                       remDuration: 70,
                                       wokenDuration: 200,
                                       heartRateResult: dummyHeartRateResult,
                                       breathingRateResult: dummyBreathingRateResult,
                                       sleepStageResult: dummySleepStageResultJournal,
                                       radarValues: [0,0,0,0,0],
                                       xAxisSteps: dummyJournalXAxisSteps10,
                                       dates: [true,true,true,true,true,true,true,true,true,true,
                                               false,false,false,false,false,false,false,false,false,false,
                                               false,false,false,false,false,false,false,false,false,false,false],
//                                       alarmOnTime: 1410,
//                                       targetTime: 1430,
//                                       timerDifference: 20,
                                       wakeUpState: 1,
                                       biosignalRecommendations: [Recommendation(priority: 1, recommendation: "NORMAL_BIOSIGNAL_RANGE", token: "NORMAL_HR")],
                                       sleepRecommendations: [Recommendation(priority: 1, recommendation: "CHECK_ENV", token: "NORMAL_BR")],
                                         radarRecommendations: [Recommendation(priority: 1, recommendation: "CHECK_ENV", token: "NORMAL_BR")],
                                       temperatureResult: dummytemperature,
                                       humidityResult: dummyhumidity,
                                       audioResult: dummyaudio,
                                       sleepDebt: -75)

let dummyJournalData = JournalResponse(hasPremium: true,
                                       journalDate: "2022-07-19T15:00:00Z",
                                       sleepQuality: 89,
                                       sleepEfficiency: 90,
                                       lightDuration: 120,
                                       deepDuration: 48,
                                       remDuration: 70,
                                       wokenDuration: 200,
                                       heartRateResult: dummyHeartRateResult,
                                       breathingRateResult: dummyBreathingRateResult,
                                       sleepStageResult: dummySleepStageResultJournal,
                                       radarValues: [85,90,99,67,58],
                                       xAxisSteps: dummyJournalXAxisSteps10,
                                       dates: [true,true,true,true,true,true,true,true,true,true,
                                               false,false,false,false,false,false,false,false,false,false,
                                               false,false,false,false,false,false,false,false,false,false,false],
//                                       alarmOnTime: 1410,
//                                       targetTime: 1430,
//                                       timerDifference: 20,
                                       wakeUpState: 2,
                                       biosignalRecommendations: [Recommendation(priority: 1, recommendation: "NORMAL_BIOSIGNAL_RANGE", token: "NORMAL_HR")],
                                       sleepRecommendations: [Recommendation(priority: 1, recommendation: "CHECK_ENV", token: "NORMAL_BR")],
                                         radarRecommendations: [Recommendation(priority: 1, recommendation: "CHECK_ENV", token: "NORMAL_BR")],
                                       temperatureResult: dummytemperature,
                                       humidityResult: dummyhumidity,
                                       audioResult: dummyaudio,
                                       sleepDebt: -75
                                       
)

let dummyaudio = SignalResult(
    values: [9, 14, 12, 12, 12, 13, 12],
    variability: [1, 2, 3, 3, 4, 4, 2],
    maxValue: [17,10,9,4,8,13,12],
    minValue: [5,8,6,3,4,4,7],
    average: [12,12,12,12,12,12,12]
)

let dummyhumidity = SignalResult(
    values: [22,33,24,44,52,40,50],
    variability: [1, 1, 1, 1, 1, 1, 1],
    maxValue: [26,35,29,46,55,43,53],
    minValue: [20,30,20,40,50,37,45],
    average: [34,34,34,34,34,34,34])

let dummytemperature = SignalResult(
    values: [21, 21, 21, 21, 23, 23, 23],
    variability: [1, 1, 1, 1, 1, 1, 1],
    maxValue: [22, 24, 24, 22, 23, 21, 22],
    minValue: [21, 23, 22, 21, 21, 21, 21],
    average: [23, 23, 23, 23, 23, 23, 23])


let rawdummyJ =
"000000000000000000000233333332333333333333300002223222344444422222222221122223332223333232112112222023332223333232111222000002222000222020221111102233333333200"


let dummyJ = rawdummyJ.compactMap{Int(String($0))}

let dummySleepStageResultJournal = SleepStageResult(sleepStart: [894],
                                             sleepEnd: [1381],
                                             sleepDuration: [481],
                                             sleepStages: [dummyJ]
)

let dummyJournalXAxisSteps: [String] = ["23:54", "01:06", "02:18", "03:30", "04:42", "05:54", "07:06"]
let dummyJournalXAxisSteps10: [String] = ["23","24","1","2","3","4","5","6","7","8"]

let dummyHeartRateResult = SignalResult(
    values: [57,50,55,75,55,53,55,48,55,48],
    variability: [15,10,10,25,15,10,8,13,8,13],
    maxValue: [77],
    minValue: [48],
    average: [62])

//let dummyHeartRateResult = BiosignalResult(
//    values: [54,50,55,54,55,55,57,56,55,60,
//             58,60,62,57,56,73,66,78,60,56,
//             51,52,51,55,50,55,52,68,66,53,
//             57,52,51,49,63,55,56,57,55,58,
//             58,59,62,59,54,60,62,66,69,56,
//             60,55,54,55,50,51,52,50,56,56,
//             56,53,54,56,54,53,54,54,54,54,
//             56,53,53,53,51,56,57,57,62,54,
//             53,54,57,56,55,57,54,57,58,81,
//             54,56,55,69,55,61,62,60,62,60,
//             66,60,65,55,62,65,69,59,60,76,
//             33,62,57,57,57,56,55,55,56,55],
//    variability: [8,7,3,6,5,3,5,8,7,3,
//                  8,7,3,6,5,3,5,8,7,3,
//                  8,7,3,6,5,3,5,8,7,3,
//                  8,7,3,6,5,3,5,8,7,3,
//                  8,7,3,6,5,3,5,8,7,3,
//                  8,7,3,6,5,3,5,8,7,3,
//                  8,7,3,6,5,3,5,8,7,3,
//                  8,7,3,6,5,3,5,8,7,3,
//                  8,7,3,6,5,3,5,8,7,3,
//                  8,7,3,6,5,3,5,8,7,3,
//                  8,7,3,6,5,3,5,8,7,3,
//                  8,7,3,6,5,3,5,8,7,3],
//    maxValue: [81],
//    minValue: [24])

let dummyBreathingRateResult = SignalResult(
    values:      [12 ,16,  14,16.5,16,  16,  14,15,  15,  14],
    variability: [2.5, 1, 1.8, 1.4, 1, 1.6, 1.9, 2, 2.3, 2.5],
    maxValue: [17],
    minValue: [12],
    average: [14]
)
