//
//  DropdownOption.swift
//  mellowing-factory
//
//  Created by Florian Topf on 03.01.22.
//

import SwiftUI

struct DropdownOption: Hashable, Identifiable {
    let id = UUID()
    
    let key: String
    let value: String

    public static func ==(lhs: DropdownOption, rhs: DropdownOption) -> Bool {
        return lhs.key == rhs.key
    }
}
