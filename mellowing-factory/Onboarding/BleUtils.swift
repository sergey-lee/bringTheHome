//
//  BleScanUtils.swift
//  mellowing-factory
//
//  Created by 김민수 on 2021/12/19.
//

import Foundation
import CoreBluetooth

func byteArrayToBase64String(data: Data) -> String {
  let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
  return base64String
}

func base64StringToData(data: String) -> Data {
  let data: Data = Data(base64Encoded: data, options: .ignoreUnknownCharacters)!
  return data
}

func getMatchedScanData(mac: String) -> [String: Any]? {
  guard let scanData = scannedPeripheralDic[mac] else {
    return nil
  }
  let bleDevice: BleDevice = scanData["bleDevice"] as! BleDevice
  let currentTimestamp: Double = NSDate().timeIntervalSince1970
  if(currentTimestamp - bleDevice.scanTimestamp < 1500){
    return scanData
  }
  return nil
}

func getMacFromManufacturerData(array: [UInt8]) -> String {
  var mac = ""
  for i in 3..<9 {
    let _hex = String(format:"%02X", array[i])
    mac += (_hex.count == 2 ? _hex : "0" + _hex);
    if (i != 8){
      mac += ":";
    }
  }
  return mac
}

func getFVFromManufacturerData(array: [UInt8]) -> Int {
  return Int((array[2] & 0x3E) >> 1)
}

func getREVFromManufacturerData(array: [UInt8]) -> Int {
  return Int(array[2] >> 6)
}

func getInitModeFromManufacturerData(array: [UInt8]) -> Int {
  return Int(array[2] & 0x01)
}

func getThingName(data: [UInt8]) -> String {
  var newArr = [UInt8]()
  for i in 3..<data.count {
    newArr.append(data[i])
  }
  if let string = String(bytes: newArr, encoding: .utf8) {
      return string
  } else {
      return ""
  }
}

func bytesToString(data: [UInt8]) -> String {
//  print(data)
//  print(data.count)
  var newArr = [UInt8]()
    
    guard data.count > 1 else { return "" }
    
  for i in 2..<data.count {
      if data[i] != 0 {
          newArr.append(data[i])
      }
  }
  print(newArr)
  print(newArr.count)
    if let string = String(bytes: newArr, encoding: .ascii) {
      print(string)
      return string
    } else if let string = String(bytes: newArr, encoding: .utf8) {
        print(string)
        return string
    } else {
      return "error"
  }
}

func objectToJson(from object: Any) -> String? {
  guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
      return nil
  }
  return String(data: data, encoding: String.Encoding.utf8)
}
