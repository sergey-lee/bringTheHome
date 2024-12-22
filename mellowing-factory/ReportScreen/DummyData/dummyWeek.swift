//
//  dummyData.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/05.
//

import Foundation

let weeklyPlaceholder = StatisticsResponse(id: "dummy", created: "2022-07-04T06:39:19.661Z",
                                                      sleepStages: dummySleepStageResult,
                                                      radarValues: dummyRadarResult,
                                                      heartRate: dummyJournalHeart,
                                                      breathingRate: dummyJournalBreathing,
                                                      sleepQuality: [0,0,0,0,0,0,0],
                                                      sleepLatency: [7,18,5,6,0,17,19],
                                                      lightDuration: [67,60,74,83,0,86,75],
                                                      sleepEfficiency: [96,97,98,97,0,90,97],
                                                      deepDuration: [67,60,74,83,86,0,75],
                                                      remDuration: [89,87,95,80,0,90,99],
                                                      wokenDuration: [20,25,30,20,0,30,10],
                                                      wakeUpState: [0,0,0,0,0,0,0],
                                                      updated: "2023-01-31T07:32:33.654Z",
                                                      percentageChangeRadar: [-12, 36, 32, 19, -10],
                                                      sleepDebt: [138,-105,-96,-95,0,153,-82],
                                                      temperature: dummytemperature,
                                                      humidity: dummyhumidity,
                                                      audio: dummyaudio
)


let dummyRadarResult: [[Double]] = [
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0],
    [0,0,0,0,0]
    
//    [89,87,95,80,99],
//    [76,57,68,97,97],
//    [66,87,48,67,37],
//    [46,77,98,97,57],
//    [0,0,0,0,0],
//    [75,97,86,90,85],
//    [90,90,98,97,99],
]

let dummySleepStageResult = SleepStageResult(sleepStart: [820, 820, 820, 882, 882, 820, 820],
                                             sleepEnd: [376,376,376,376,376,376,376],
                                             sleepDuration: [474,474,474,474,474,474,474],
//                                             sleepStages: [ dummyJ, dummy2, dummy3, dummy4, dummy6, dummy5, dummy7]
                                             sleepStages: [ [0], [0], [0], [0], [0], [0], [0]]
)

let rawdummy1 = "00000000000000000000023333333233333333333330000222322233212222222112222023332223333232111222000002222000222020221111102233333333200"
let rawdummy2 = "0000000000023003230000100002300000001110022223330333002110222222333333021110022023222232333212101000000000000"
let rawdummy3 = "000000000000000022222320222222022211110022222222332222222202202222222111110000000222222222222211111112222222222222211122222022002221100"
let rawdummy4 = "00000000000222333333333333333300221212222220002222222233333330211112222222200223330022222022220222210000000000022111102"
let rawdummy5 = "00000000022222233300002222112233333333333333222111102222222232222232301110000002233332321112220000022220002220202211111022330222222232211110000000222222200200000000"
let rawdummy6 = "0"
let rawdummy7 = "000000000000000000002222323322232202220222202223333202202222202222223232322322211111111212222222222000000000022221123333333221111220200"

let dummy1 = rawdummy1.compactMap{Int(String($0))}
let dummy2 = rawdummy2.compactMap{Int(String($0))}
let dummy3 = rawdummy3.compactMap{Int(String($0))}
let dummy4 = rawdummy4.compactMap{Int(String($0))}
let dummy5 = rawdummy5.compactMap{Int(String($0))}
let dummy6 = rawdummy6.compactMap{Int(String($0))}
let dummy7 = rawdummy7.compactMap{Int(String($0))}

let dummyJournalBreathing = SignalResult(
    values: [14,14,14,14,14,14,20],
    variability: [0, 2.1, 1.8, 1.6, 1.7, 2, 1.9],
    maxValue: [13, 18, 17, 17, 23, 16, 17],
    minValue: [ 8,  7,  7,  8,  7, 13, 11],
    average: [10, 12, 11, 12, 17, 14, 14]
    
)

let dummyJournalHeart = SignalResult(
    values: [55,64,53,51,49,69,56],
    variability: [8,7,3,6,5,3,5],
    maxValue: [83,83,83,83,83,83,83],
    minValue: [47,49,47,46,47,47,47],
    average: [63,63,63,63,63,63,63]
)

let ellieStatBreathing = SignalResult(
    values: [14,14,14,14,14,14,20],
    variability: [0, 2.1, 1.8, 1.6, 1.7, 2, 1.9],
//    maxValue: [20,20,20,20,20,20,20,],
//    minValue: [7,7,7,7,7,7,7]
    maxValue: [13, 18, 17, 17, 23, 16, 17],
    minValue: [ 8,  7,  7,  8,  7, 13, 11],
    average: [10, 12, 11, 12, 17, 14, 14]
)

let ellieStatHeart = SignalResult(
    values: [55,64,53,51,49,69,56],
    variability: [],
    maxValue: [58,63,59,60,52,54,70],
    minValue: [50,55,50,49,46,50,52],
    average: [54,54,54,54,54,54,54])
