//
//  FrontendApi.swift
//  mellowing-factory
//
//  Created by Florian Topf on 15.11.21.
//

import Foundation
import Amplify

final class FrontendApi {
    private static let API_NAME = "SoundApi"
    private let statisticsCache = Cache<StatisticsTimeFrame, StatisticsResponse>()
    private let journalCache = Cache<Date, JournalResponse>()
    
    func getJournal(id: String,
                    journalDate: Date,
                    completion: @escaping (ApiResult<JournalResponse>) -> Void) {
        
        if let cachedResponse: JournalResponse = journalCache[journalDate] {
            completion(.success(cachedResponse))
            return
        }
        
        let request = RESTRequest(apiName: FrontendApi.API_NAME,
                                  path: "/journal/\(id)/\(journalDate.toISODate())")
        
//        Amplify.API.get(request: request) { result in
//            switch result {
//            case .success(let data):
//                let str = String(decoding: data, as: UTF8.self)
//                print("Get journal success \(str)")
//                if let response: JournalResponse = decodeJson(data: data) {
//                    self.journalCache[journalDate] = response
//                    completion(.success(response))
//                } else {
//                    completion(.failure(ApiError.invalidJSON))
//                }
//            case .failure(let error):
//                print("Get journal failure \(error)")
//                completion(.failure(ApiError.httpError))
//            }
//        }
//    }
//    
//    func getStatistics(id: String,
//                       timeFrame: StatisticsTimeFrame,
//                       completion: @escaping (ApiResult<StatisticsResponse>) -> Void) {
//        
//        if let cachedResponse: StatisticsResponse = statisticsCache[timeFrame] {
//            completion(.success(cachedResponse))
//            return
//        }
//        
//        let request = RESTRequest(apiName: FrontendApi.API_NAME,
//                                  path: "/statistics/\(id)/\(timeFrame)")
//        
//        Amplify.API.get(request: request) { result in
//            switch result {
//            case .success(let data):
//                let str = String(decoding: data, as: UTF8.self)
//                print("Get statistics success \(str)")
//                if let response: StatisticsResponse = decodeJson(data: data) {
//                    self.statisticsCache[timeFrame] = response
//                    completion(.success(response))
//                } else {
//                    completion(.failure(ApiError.invalidJSON))
//                }
//            case .failure(let error):
//                print("Get statistics failure \(error)")
//                completion(.failure(ApiError.httpError))
//            }
//        }
    }
}
