//
//  BleCommands.swift
//  mellowing-factory
//
//  Created by 김민수 on 2021/12/19.
//

import Foundation

func createGetWiFiListCommand() -> [UInt8] {
    var payload = [UInt8]();
    payload.append(HEAD_DEVICE_GET_WIFI_LIST);
    payload.append(0x00);
    payload.append(0x00);
    return payload;
}

func createWifiSettingCommand(ssid: String, pass: String) -> [UInt8] {
    let wifiData: [String:Any] = ["wifi": ssid, "pass": pass, "offset": String(TIME_OFFSET_MINUTES)]
    let jsonString = objectToJson(from: wifiData)
    let array: [UInt8] = Array(jsonString!.utf8)
    
    var payload = [UInt8]();
    payload.append(HEAD_DEVICE_SET_WIFI_DATA);
    payload.append(0x00);
    payload.append(0x00);
    for byte in array {
      payload.append(byte)
    }
    return payload;
}

func createDeviceRestartCommand() -> [UInt8] {
    var payload = [UInt8]();
    payload.append(HEAD_DEVICE_RESTART);
    payload.append(0x00);
    payload.append(0x00);
    return payload;
}

func createTestCommand() -> [UInt8] {
    var payload = [UInt8]();
    payload.append(HEAD_DEVICE_TEST);
    payload.append(0x00);
    payload.append(0x00);
    print(payload)
    return payload;
}
