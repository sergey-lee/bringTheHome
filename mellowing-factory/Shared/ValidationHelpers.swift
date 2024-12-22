//
//  ValidationHelpers.swift
//  mellowing-factory
//
//  Created by Florian Topf on 06.02.22.
//

import Foundation

// regex from: https://stackoverflow.com/questions/201323/how-can-i-validate-an-email-address-using-a-regular-expression
func isEmailValid(email: String) -> Bool {
    do {
        let range = NSRange(location: 0, length: email.utf16.count)
        let regex = try NSRegularExpression(pattern: "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])")
        return regex.firstMatch(in: email, options: [], range: range) != nil
    } catch {
        return false
    }
}

func isPasswordValid(password: String) -> Bool {
    do {
        let range = NSRange(location: 0, length: password.utf16.count)
        let regex = try NSRegularExpression(pattern: "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$")
        return regex.firstMatch(in: password, options: [], range: range) != nil
    } catch {
        return false
    }
}
