//
//  BleScanResult.swift
//  mellowing-factory
//
//  Created by 김민수 on 2021/12/19.
//

import Foundation

struct BleScanResult {
  var error: Bool = false
  var errorCode: Int = 0x00
  var errorData: String = "default"
  var msgCode: String = "default"
  var rssi: Int = 0
  var bleDevice: BleDevice = BleDevice()
  
  init(errorData: String, errorCode: Int) {
    self.error = true
    self.errorData = errorData
    self.errorCode = errorCode
  }
  
  init(rssi: Int, bleDevice: BleDevice){
    self.rssi = rssi
    self.bleDevice = bleDevice
  }
  
//  var toMap: Any{
//    return [
//      "error":error,
//      "code": errorCode,
//      "errorCode": errorCode,
//      "errorData": errorData,
//      "msgCode": msgCode,
//      "rssi": rssi,
//      "bleDevice": bleDevice.toMap
//    ]
//  }
}
