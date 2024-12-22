//
//  SensorData.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/14.
//

import Foundation

struct SensorData: Codable {
    var breathRate: Int
    var updated: String?
    var entropy: Double
    var created: String?
    var valid: Int
    var id: String
    var heartRate: Int
}

struct GetSensorDataResponse: Codable {
    var data: [SensorData]
}
