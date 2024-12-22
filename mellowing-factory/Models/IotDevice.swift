//
//  IotDevice.swift
//  mellowing-factory
//
//  Created by Florian Topf on 28.01.22.
//

struct IotDevice: Codable {
    var id: String
//    var mac: String
    var rev: Int
    var fv: Int
    var created: String?
    var updated: String?
//    var mode: Int?
    var name: String?
//    var strength: Int?
    var sleepInductionState: SleepInductionState
    var isTested: Bool?
}

struct SleepInductionState: Codable, Equatable {
    var isOn: Bool
    var isSmart: Bool
    var isManual: Bool
    var strength: Int
    var mode: Int?
//    var isPersonalised: Bool
}

struct CreateIotDeviceRequest: Codable {
    var u_id: String
    var item: IotDevice
}

struct GetIotDeviceResponse: Codable {
    var data: [IotDevice]
}

struct GetIotDeviceAndFlagResponse: Codable {
    var data: IotDevice
    var code: Int
    var isUpdated: Bool
}

struct UpdateIotDeviceRequest: Codable {
    var d_id: String
    var item: UpdateBody
}

struct TestDeviceRequest: Codable {
    var d_id: String
    var mode: Int
    var interval: Int
//    var duration: Int
    var strength: Int?
    var test: Bool
}

struct stopVibrationRequest: Codable {
    var d_id: String
}

struct UpdateBody: Codable {
    var name: String
    var rev: Int
    var fv: Int
//    var mode: Int?
    var isTested: Bool?
    var sleepInductionState: SleepInductionState
}

struct CreateEndSleepRequest: Codable {
    var d_id: String
}

