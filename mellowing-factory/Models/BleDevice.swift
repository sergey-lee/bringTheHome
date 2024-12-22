//
//  BleDevice.swift
//  mellowing-factory
//
//  Created by 김민수 on 2021/12/19.
//

import Foundation

class BleDevice {
  var map: NSDictionary?
  
  var flag: Int?
  var mac: String?
  var name: String?
  var fv: Int?
  var rev: Int?
  var manuData: String?
  var identifier: String?
  var scanTimestamp: Double = NSDate().timeIntervalSince1970
  
  func mapping(map: NSDictionary) {
    flag = map["flag"] as? Int
    mac = map["mac"] as? String
    name = map["name"] as? String
    fv = map["fv"] as? Int
    rev = map["rev"] as? Int
    scanTimestamp = map["scanTimestamp"] as? Double ?? 0
    manuData = map["manuData"] as? String ?? ""
    self.map = map
  }
  
//  var toJSObject: [String: Any]{
//    return [
//      "flag": flag ?? 0,
//      "mac": mac ?? "",
//      "name": name ?? "",
//      "fv": fv ?? 0,
//      "rev": rev ?? 0,
//      "scanTimestamp": scanTimestamp,
//      "manuData": manuData,
//      "identifier": identifier
//    ]
//  }
}
