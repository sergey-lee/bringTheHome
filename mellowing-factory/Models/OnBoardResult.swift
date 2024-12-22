//
//  OnBoardResult.swift
//  mellowing-factory
//
//  Created by 김민수 on 2021/12/19.
//

import Foundation

struct OnBoardResult {
    var error: Bool = false
    var code: Int = 0
    var errorData: String = ""
    var data: IotDevice? = nil
    var wifiList: [String] = []
    
    var testData: TestData? = nil
    
    init(code: Int, errorData: String) {
        self.error = true
        self.errorData = errorData
        self.code = code
      }
      
    init(data: IotDevice?) {
      self.data = data
    }
    
    init(wifiList: [String]) {
        self.wifiList = wifiList
    }
    
    init(testData: TestData) {
        self.testData = testData
    }
    
    var toMap: [String:Any] {
        return [
            "error": error,
            "code": code,
            "errorData": errorData,
            "data": data ?? "",
        ]
    }
}
