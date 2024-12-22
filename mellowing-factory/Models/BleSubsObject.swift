//
//  BleSubsObject.swift
//  mellowing-factory
//
//  Created by 김민수 on 2021/12/19.
//

import Foundation

class BleSubsObject {
  var mac: String!
  var p_id: Int! //process id
  var idenfiier: String!
  var bleCallback: ((String, [String: Any]) -> Void)!
}
