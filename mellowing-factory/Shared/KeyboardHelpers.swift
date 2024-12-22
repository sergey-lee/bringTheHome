//
//  KeyboardHelpers.swift
//  mellowing-factory
//
//  Created by Florian Topf on 20.01.22.
//

import SwiftUI
import Foundation

func closeKeyboard() {
    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
    )
}
