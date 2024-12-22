//
//  WifiUtils.swift
//  mellowing-factory
//
//  Created by Florian Topf on 12.01.22.
//

import NetworkExtension
import CoreLocation

struct NetworkList {
    static var values: [String] = []
    static var espRequestCompleted: Bool = false
    
    static func isIncomplete() -> Bool {
        return NetworkList.espRequestCompleted && NetworkList.values.isEmpty
    }
    
    static func getDropdownValues() -> [DropdownOption] {
        return NetworkList.values.map {
            DropdownOption(key: UUID().uuidString, value: "\($0)")
        }
    }
}

