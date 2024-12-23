//
//  DataCenter.swift
//  mellowing-factory
//
//  Created by 김민수 on 2021/12/19.
//

import Foundation
import CoreBluetooth

/*
BLE UUID
*/
let DEVICE_SERVICE_UUID = "6e877c60-0e50-493f-b012-3a86acf4610e";
let DEVICE_WRITE_UUID = "6e877c61-0e50-493f-b012-3a86acf4610e";
let DEVICE_NOTIF_UUID = "6e877c62-0e50-493f-b012-3a86acf4610e"

let DEVICE_SERVICE_CBUUID = CBUUID(string: DEVICE_SERVICE_UUID)
let DEVICE_WRITE_CHAR_CBUUID = CBUUID(string: DEVICE_WRITE_UUID)
let DEVICE_NOTIF_CHAR_CBUUID = CBUUID(string: DEVICE_NOTIF_UUID)

let SERVICES_LIST = [DEVICE_SERVICE_CBUUID]

/*
  BLE SCAN STATE CODE
*/
let SCAN_SUCCESS: Int = 0xD7;
let DEVICE_SCAN_ERROR: Int = 0xD8;


/*
  BLE STATE CODE
*/
let BLE_POWER_ON: Int = 0;
let BLE_POWER_OFF: Int = 1;
let BLE_UNAUTHORIZED: Int = 2;
let BLE_UNSUPPORTED: Int = 3;
let BLE_RESETTING: Int = 4;


let BLE_RECEIVED_INVALID_DATA: Int = 209;
let BLE_SEND_ERROR: Int = 210;
let BLE_NOTIFY_ERROR: Int = 211;
let BLE_CONNECT_ERROR: Int = 212;
let BLE_TIME_OUT: Int = 213;
let BLE_UNKNOWN: Int = 214;

let DEVICE_NOT_FOUND: Int = 208;
let DEVICE_SUCCESS: Int = 253;
let DEVICE_CANNOT_CONNECT_WIFI: Int = 16;
let DEVICE_SUCCESS_0: Int = 0;

/*
    DEVICE COMMANDS
 */
let HEAD_DEVICE_RESTART: UInt8 = 17;
let HEAD_DEVICE_SET_WIFI_DATA: UInt8 = 18;
let HEAD_DEVICE_GET_WIFI_LIST: UInt8 = 19;
let HEAD_DEVICE_TEST: UInt8 = 20;
