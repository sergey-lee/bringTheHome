//
//  BleResult.swift
//  mellowing-factory
//
//  Created by 김민수 on 2021/12/19.
//

import Foundation

struct BleResult {
    var error: Bool = false;
    var errorData: String = "";
    var code: Int = Int(DEVICE_SUCCESS);
    var resultData: String = "";
    
    init(resultData: String) {
        self.resultData = resultData;
    }
    
    init(errorCode: Int, errorData: String) {
        self.error = true;
        self.code = errorCode;
        self.errorData = errorData;
    }
    
    var toMap: [String:Any] {
        return [
            "error": error,
            "errorData": errorData,
            "code": code,
            "resultData": resultData,
        ]
    }
}
