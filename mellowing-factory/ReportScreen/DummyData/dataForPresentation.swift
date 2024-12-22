//
//  dataForPresentation.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/09.
//

import Foundation

let presentationAccount = "joon@mellowingfactory.com"
let kickStarterDemoAccount = "kickstarter@wethm.com"

//let presentationAccount = "guagetru.bla@inbox.ru"

func presentStatistics(timeFrame: StatisticsTimeFrame, date: Date) -> StatisticsResponse {
    let userCalendar = Calendar(identifier: .gregorian)
    
    var year2022dateComponents = DateComponents()
    year2022dateComponents.year = 2022
    let year2022 = userCalendar.date(from: year2022dateComponents)!
    
    var year2023dateComponents = DateComponents()
    year2023dateComponents.year = 2023
    let year2023 = userCalendar.date(from: year2023dateComponents)!
    
    switch timeFrame {
    case .monthly:
        if date.isInFuture {
            return monthlyPlaceholder
        } else {
            return testerMonthly
        }
    case .yearly:
        if date.isSameYear(date2: year2022) {
            return testerYearly2022
        } else if date.isSameYear(date2: year2023) {
            return testerYearly2023
        } else {
            return yearlyPlaceholder
        }
    default:
        return weeklyPlaceholder
    }
    
}

let ellie = StatisticsResponse(id: presentationAccount, created: "2023-03-11T06:39:19.661Z",
                               sleepStages: ellieStages,
                               radarValues: ellieRadar,
                               heartRate: ellieStatHeart,
                               breathingRate: ellieStatBreathing,
                               sleepQuality: [100,95,90,85,85,75,89],
                               sleepLatency: [7,18,5,6,0,17,19],
                               lightDuration: [67,60,74,83,0,86,75],
                               sleepEfficiency: [96,97,98,97,0,90,97],
                               deepDuration: [67,60,74,83,86,0,75],
                               remDuration: [89,87,95,80,0,90,99],
                               wokenDuration: [20,25,30,20,0,30,10],
                               wakeUpState: [0,0,0,0,0,0,0],
                               updated: "2023-03-13T06:39:19.661Z",
                               percentageChangeRadar: [10, -10, -10, 10, -3],
                               sleepDebt: [138,-105,-96,-95,0,96,-72],
                               temperature: dummytemperature,
                               humidity: dummyhumidity,
                               audio: dummyaudio
)

let grandma = StatisticsResponse(id: "grandma", created: "2022-07-04T06:39:19.661Z",
                                 sleepStages: grandmaStages,
                                 radarValues: grandmaRadar,
                                 heartRate: grandmaHeart,
                                 breathingRate: grandmaBreathing,
                                 sleepQuality: [100,95,90,85,0,75,88],
                                 sleepLatency: [7,18,5,6,0,17,19],
                                 lightDuration: [67,60,74,83,0,86,75],
                                 sleepEfficiency: [96,97,98,97,0,90,97],
                                 deepDuration: [67,60,74,83,86,0,75],
                                 remDuration: [89,87,95,80,0,90,99],
                                 wokenDuration: [20,25,30,20,0,30,10],
                                 wakeUpState: [0,0,0,0,0,0,0],
                                 percentageChangeRadar: [-12, -36, -32, 19, 10],
                                 sleepDebt: [138,-38,-96,-95,0,153,-82],
                                 temperature: dummytemperature,
                                 humidity: dummyhumidity,
                                 audio: dummyaudio
)

let mom = StatisticsResponse(id: "mom", created: "2022-07-04T06:39:19.661Z",
                             sleepStages: momStages,
                             radarValues: momRadar,
                             heartRate: momHeart,
                             breathingRate: momBreathing,
                             sleepQuality: [100,95,90,85,0,75,94],
                             sleepLatency: [7,18,5,6,0,17,19],
                             lightDuration: [67,60,74,83,0,86,75],
                             sleepEfficiency: [96,97,98,97,0,90,97],
                             deepDuration: [67,60,74,83,86,0,75],
                             remDuration: [89,87,95,80,0,90,99],
                             wokenDuration: [20,25,30,20,0,30,10],
                             wakeUpState: [0,0,0,0,0,0,0],
                             percentageChangeRadar: [-12, 36, -32, 19, -10],
                             sleepDebt: [138,-38,-96,-95,0,153,-82],
                             temperature: dummytemperature,
                             humidity: dummyhumidity,
                             audio: dummyaudio)


let dad = StatisticsResponse(id: "dad", created: "2022-07-04T06:39:19.661Z",
                             sleepStages: dadStages,
                             radarValues: dadRadar,
                             heartRate: momHeart,
                             breathingRate: momBreathing,
                             sleepQuality: [100,95,90,85,0,75,91],
                             sleepLatency: [7,18,5,6,0,17,19],
                             lightDuration: [67,60,74,83,0,86,79],
                             sleepEfficiency: [96,97,98,97,0,90,97],
                             deepDuration: [67,60,74,83,86,0,75],
                             remDuration: [89,87,95,80,0,90,99],
                             wokenDuration: [20,25,30,20,0,30,10],
                             wakeUpState: [0,0,0,0,0,0,0],
                             percentageChangeRadar: [-12, 36, -32, 19, -10],
                             sleepDebt: [138,-38,-96,-95,0,153,-82],
                             temperature: dummytemperature,
                             humidity: dummyhumidity,
                             audio: dummyaudio)

let michael = StatisticsResponse(id: "michael", created: "2022-07-04T06:39:19.661Z",
                                 sleepStages: dadStages,
                                 radarValues: dadRadar,
                                 heartRate: momHeart,
                                 breathingRate: momBreathing,
                                 sleepQuality: [100,95,90,85,0,75,93],
                                 sleepLatency: [7,18,5,6,0,17,19],
                                 lightDuration: [67,60,74,83,0,86,79],
                                 sleepEfficiency: [96,97,98,97,0,90,97],
                                 deepDuration: [67,60,74,83,86,0,75],
                                 remDuration: [89,87,95,80,0,90,99],
                                 wokenDuration: [20,25,30,20,0,30,10],
                                 wakeUpState: [0,0,0,0,0,0,0],
                                 percentageChangeRadar: [-12, 36, -32, 19, -10],
                                 sleepDebt: [138,-38,-96,-95,0,153,-82],
                                 temperature: dummytemperature,
                                 humidity: dummyhumidity,
                                 audio: dummyaudio)

let ellieStages = SleepStageResult(sleepStart: [820, 882, 882, 882, 882, 787, 932],
                                   sleepEnd: [40,1364,1380,1320,1290,1440,1386],
                                   sleepDuration: [678,306,299,250,430,636,454],
                                   sleepStages: [ dummyJ, dummy2, dummy3, dummy4, dummy2, dummy5, dummy7]
)

let grandmaStages = SleepStageResult(sleepStart: [820, 882, 882, 882, 882, 787, 764],
                                     sleepEnd: [376,461,439,343,434,1265,1245],
                                     sleepDuration: [474,477,485,476,479,478,481],
                                     sleepStages: [ dummyJ, dummy2, dummy3, dummy4, dummy6, dummy5, dummy7]
)

let momStages = SleepStageResult(sleepStart: [820, 882, 882, 882, 882, 787, 816],
                                 sleepEnd: [376,461,439,343,434,1265,1261],
                                 sleepDuration: [474,477,485,476,479,478,350],
                                 sleepStages: [ dummyJ, dummy2, dummy3, dummy4, dummy6, dummy5, dummy7]
)

let dadStages = SleepStageResult(sleepStart: [820, 882, 882, 882, 882, 787, 787],
                                 sleepEnd: [376,461,439,343,434,1265,511],
                                 sleepDuration: [474,477,485,476,479,478,444],
                                 sleepStages: [ dummyJ, dummy2, dummy3, dummy4, dummy6, dummy5, dummy7]
)

let ellieRadar: [[Double]] =
[
    [70,95,98,73,90],
    [89,87,95,80,99],
    [70,95,98,73,90],
    [70,100,100,73,90],
    [70,100,100,73,90],
    [85,95,98,73,90],
    [70,95,98,73,90],
    [85,85,85,85,85],
]

let grandmaRadar: [[Double]] = [
    [89,87,95,80,99],
    [66,87,48,67,37],
    [0,0,0,0,0],
    [75,97,86,90,85],
    [90,90,98,97,99],
    [46,77,98,97,57],
    [86,67,78,97,97],
    //    [76,57,68,97,97],
]

let momRadar: [[Double]] = [
    [89,87,95,80,99],
    [89,87,95,80,99],
    [89,87,95,80,99],
    [89,87,95,80,99],
    [89,87,95,80,99],
    [89,87,95,80,99],
    [89,87,95,80,99]
]

let dadRadar: [[Double]] = [
    [89,87,95,80,99],
    [89,87,95,80,99],
    [89,87,95,80,99],
    [89,87,95,80,99],
    [89,87,95,80,99],
    [89,87,95,80,99],
    [89,87,95,80,99]
]

let weeklyRadar: [[Double]] = [
    [89,87,95,80,99],
    [76,57,68,97,97],
    [66,87,48,67,37],
    [46,77,98,97,57],
    [0,0,0,0,0],
    [75,97,86,90,85],
    [90,90,98,97,99],
]

let weeklySleepStageResult = SleepStageResult(sleepStart: [820, 820, 820, 882, 882, 820, 820],
                                              sleepEnd: [376,376,376,376,376,376,376],
                                              sleepDuration: [474,474,474,474,474,474,474],
                                              sleepStages: [ dummyJ, dummy2, dummy3, dummy4, dummy6, dummy5, dummy7]
                                              
)

let grandmaHeart = SignalResult(
    values: [55,60,53,51,49,52,60],
    variability: [8,7,3,6,5,3,5],
    maxValue: [58,63,59,60,52,54,70],
    minValue: [50,55,50,49,46,50,52],
    average: [50,55,50,49,46,50,52]
)

let grandmaBreathing = SignalResult(
//    values: [0, 11, 10, 9, 8, 0, 8],
//    variability: [0, 2.1, 1.8, 1.6, 1.7, 0, 1.9],
//    maxValue: [0, 12, 13, 12, 11, 0, 31],
//    minValue: [0, 7, 7, 8, 7, 0, 7],
//    average: [0, 7, 7, 8, 7, 0, 7]
    values: [12,12,12,12,12,12,12],
    variability: [1,1,1,1,1,1,1],
    maxValue: [16,16,16,16,16,16,16],
    minValue: [8,8,8,8,8,8,8],
    average: [15,15,15,15,15,15,15]
)

let momHeart = SignalResult(
    values: [55,60,53,51,49,52,60],
    variability: [8,7,3,6,5,3,5],
    maxValue: [58,63,59,60,52,54,63],
    minValue: [50,55,50,49,46,50,53],
    average: [0, 7, 7, 8, 7, 0, 7]
)

let momBreathing = SignalResult(
    values: [12,12,12,12,12,12,12],
    variability: [1,1,1,1,1,1,1],
    maxValue: [21,21,21,21,21,21,21],
    minValue: [11,11,11,11,11,11,11],
    average: [15,15,15,15,15,15,15]
//    values: [0, 11, 10, 9, 8, 0, 8],
//    variability: [0, 2.1, 1.8, 1.6, 1.7, 0, 1.9],
//    maxValue: [0, 12, 13, 12, 11, 0, 13],
//    minValue: [0, 7, 7, 8, 7, 0, 9],
//    average: [0, 7, 7, 8, 7, 0, 9]
)

let weeklyaudio = SignalResult(
    values: [7, 7, 8, 9, 9, 13, 12, 11],
    variability: [1, 2, 3, 3, 4, 4, 2],
    maxValue: [17],
    minValue: [8],
    average: [12]
)

let weeklyhumidity = SignalResult(
    values: [35, 35, 35, 35, 35, 35],
    variability: [1, 1, 1, 1, 1, 1],
    maxValue: [40],
    minValue: [32],
    average: [36]
)

let weeklytemperature = SignalResult(
    values: [26, 26, 26, 26, 26, 26],
    variability: [1, 1, 1, 1, 1, 1],
    maxValue: [26],
    minValue: [12],
    average: [19]
)

let pGroup: GroupResponse = GroupResponse(g_id: "family", created: "blank", groupName: "family", u_id: presentationAccount, updated: "blank", role: 1)


//let presentationUser = ApiNodeUser(id: presentationAccount, email: "ellie_wilson@email.com", name: "Ellie", familyName: "Wilson", membership: "extended", fakeLocation: "Dallas, TX", role: 1)
//let presentationUser = ApiNodeUser(id: presentationAccount, email: "kickstarter@wethm.com", name: "수민", familyName: "신", membership: "extended", role: 1)
let presentationUser = ApiNodeUser(id: presentationAccount, email: "kickstarter@wethm.com", name: "Backers", familyName: "Awesome", membership: "extended", fakeLocation: "Dallas, TX", role: 1)

let pListOfUsers: [ApiNodeUser] = [
//    presentationUser,
//    ApiNodeUser(id: "grandma", email: "grandma@gmail.com", name: "민지", familyName: "조"),
//    ApiNodeUser(id: "mom", email: "mom@gmail.com", name: "규현", familyName: "조"),
    presentationUser,
    ApiNodeUser(id: "grandma", email: "grandma@gmail.com", name: "Grandma", fakeLocation: "Brooklyn, NY"),
    ApiNodeUser(id: "mom", email: "mom@gmail.com", name: "Mom", fakeLocation: "Brooklyn, NY"),
    ApiNodeUser(id: "dad", email: "dad@gmail.com", name: "Dad", fakeLocation: "Brooklyn, NY"),
]

func getPresentationStatistics(id: String) -> StatisticsResponse {
    return pListOfStatistics.first(where: { $0.id == id }) ?? dad
}

let pListOfStatistics: [StatisticsResponse] = [ellieMain, grandma, mom, dad, michael]

let ellieMain = StatisticsResponse(id: presentationAccount, created: "2022-07-04T06:39:19.661Z",
                                   sleepStages: ellieStages,
                                   radarValues: ellieRadar,
                                   heartRate: mainHeart,
                                   breathingRate: mainBreath,
                                   sleepQuality: [100,95,90,85,0,75,89],
                                   sleepLatency: [7,18,5,6,0,17,19],
                                   lightDuration: [67,60,74,83,0,86,75],
                                   sleepEfficiency: [96,97,98,97,0,90,97],
                                   deepDuration: [67,60,74,83,86,0,75],
                                   remDuration: [89,87,95,80,0,90,99],
                                   wokenDuration: [20,25,30,20,0,30,10],
                                   wakeUpState: [0,0,0,0,0,0,0],
                                   percentageChangeRadar: [10, -10, -10, 10, 4],
                                   sleepDebt: [138,-105,-96,-95,0,96,-72],
                                   temperature: dummytemperature,
                                   humidity: dummyhumidity,
                                   audio: dummyaudio,
                                   recommendations: [
                                    Recommendation(priority: 2, recommendation: "CHECK_ENV", token: "EXCELLENT"),
                                    Recommendation(priority: 0, recommendation: "NORMAL_BIOSIGNAL_RANGE", token: "EFFICIENT")
                                   ]
)

let mainBreath = SignalResult(
    values: [10,10,10,10,10,10,10],
    variability: [1,1,1,1,1,1,1],
    maxValue: [19,19,19,19,19,19,19],
    minValue: [9,9,9,9,9,9,9],
    average: [14,14,14,14,14,14,14]
//    values: [14,14,14,14,14,14,14],
//    variability: [0, 2.1, 1.8, 1.6, 1.7, 0, 1.9],
//    maxValue: [13, 18, 20, 20, 21, 16, 17],
//    minValue: [8, 7, 7, 8, 7, 13, 8],
//    average: [8, 7, 7, 8, 7, 13, 8]
)

let mainHeart = SignalResult(
    values: [55,64,53,51,49,69,56],
    variability: [8,7,3,6,5,3,5],
    maxValue: [83,83,83,83,83,83,77],
    minValue: [47,49,47,46,47,47,48],
    average: [8, 7, 7, 8, 7, 13, 8]
)
