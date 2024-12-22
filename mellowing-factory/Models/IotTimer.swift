//
//  IotTimer.swift
//  mellowing-factory
//
//  Created by Florian Topf on 02.02.22.
//
import Foundation

public struct IdentifiableTimer: Identifiable, Equatable {
    public let id = UUID()
    var timer: IotTimer
}

struct IotTimer: Codable, Equatable {
    /// only set on get
    var d_id: String?
    /// only set on get
    var t_id: String?
    /// minutes of the day in utc
    var targetTime: Int
    /// set on day of the week, for now every day
    var week: [Bool] = [true, true, true, true, true, true, true]
    /// utc offset of the timezone, in seconds
    var timezone_offset: Int
    var mode: Int
    var strength: Int
    var lastActioned: String?
    var created: String?
    var updated: String?
    
    var isActive: Bool?
    var isSnoozed: Bool?
    var isSkipped: Bool?
    var lastSnooze: String?
    var isSuppressed: Bool?
}

struct CreateIotTimerRequest: Codable {
    var d_id: String
    var item: IotTimer
}

struct GetIotTimerResponse: Codable {
    var data: [IotTimer]
}

struct CreateIotTimerResponse: Codable {
    var data: IotTimer
}

struct UpdateIotTimerRequest: Codable {
    var d_id: String
    var t_id: String
    var item: IotTimer
}

struct DeleteIotTimerResponse: Codable {
    var d_id: String
    var t_id: String
}

struct SwitchTimersResponse: Codable {
    var d_id: String
}
