//
//  Defaults.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/01/04.
//

import Foundation
import SwiftUI


class Defaults {
    static var defaultGradient = LinearGradient(colors: [Color.blue200.opacity(0.4), Color.blue400.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    static var todayInitialized: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "todayInitialized")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "todayInitialized")
        }
    }
    
    static var weeklyHasData: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "weeklyHasData")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "weeklyHasData")
        }
    }
    
    static var isOnboarded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isOnboarded")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isOnboarded")
        }
    }
    
    static var isTermsCompleted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isTermsCompleted")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isTermsCompleted")
        }
    }
    
    static var isUserOnboardingCompleted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isUserOnboardingCompleted")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isUserOnboardingCompleted")
        }
    }
    
    static var appLanguage: Int {
        get {
            return UserDefaults.standard.integer(forKey: "appLanguage")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "appLanguage")
        }
    }
    
//    static var appLanguage: String {
//        get {
////            return "en"
//            if let language = UserDefaults.standard.string(forKey: "appLanguage") {
//                return language
//            } else {
//                if let locale = Locale.current.languageCode {
//                    UserDefaults.standard.set(locale, forKey: "appLanguage")
//                } else {
//                    UserDefaults.standard.set("en", forKey: "appLanguage")
//                }
//                return UserDefaults.standard.string(forKey: "appLanguage")!
//            }
//        }
//        set {
////            UserDefaults.standard.set("en", forKey: "appLanguage")
//            UserDefaults.standard.set(newValue, forKey: "appLanguage")
//        }
//    }
    
    static var autoLoginEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "autoLoginEnabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "autoLoginEnabled")
        }
    }
    
    static var saveIDEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "saveIDEnabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "saveIDEnabled")
        }
    }
    
    static var isAppOnboarded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isAppOnboarded")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isAppOnboarded")
        }
    }
    
    static var didLaunchBefore: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "didLaunchBefore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "didLaunchBefore")
        }
    }

    static var presentationMode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "presentationMode")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "presentationMode")
        }
    }
    
    static var adminName: String? {
        get {
            if let opt = UserDefaults.standard.object(forKey: "adminName") as? String {
                return opt
            }
            return nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "adminName")
        }
    }
    
    
    static var userEmailPlaceholder: String {
        get {
            return UserDefaults.standard.string(forKey: "userEmailPlaceholder") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userEmailPlaceholder")
        }
    }
    
    static var wifiName: String? {
        get {
            if let opt = UserDefaults.standard.object(forKey: "wifiName") as? String {
                return opt
            }
            return nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "wifiName")
        }
    }

    static var signInProvider: String {
        get {
            return UserDefaults.standard.string(forKey: "signInProvider") ?? "email"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "signInProvider")
        }
    }
    
    static var weightUnit: Int {
        get {
            return UserDefaults.standard.integer(forKey: "weightUnit")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "weightUnit")
        }
    }
    
    static var heightUnit: Int {
        get {
            return UserDefaults.standard.integer(forKey: "heightUnit")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "heightUnit")
        }
    }
    
    static var temperatureUnit: Int {
        get {
            return UserDefaults.standard.integer(forKey: "temperatureUnit")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "temperatureUnit")
        }
    }
    
    static var humidityUnit: Int {
        get {
            return UserDefaults.standard.integer(forKey: "humidityUnit")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "humidityUnit")
        }
    }
    
    static var skipOnboarding: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "skipOnboarding")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "skipOnboarding")
        }
    }
    
    static var mainWasShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "mainWasShown")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "mainWasShown")
        }
    }
    
    static var harmonyWasShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "harmonyWasShown")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "harmonyWasShown")
        }
    }
    
    static var reportWasShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "reportWasShown")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "reportWasShown")
        }
    }
    
    static var enhanceWasShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "enhanceWasShown")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "enhanceWasShown")
        }
    }
    
    static var addUserHintWasShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "addUserHintWasShown")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "addUserHintWasShown")
        }
    }
    
    //------
    
    static var version: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        else {
            return ""
        }
        return version
    }

    static var build: String {
        guard let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        else {
            return ""
        }
        return build
    }
    
    static var iPhoneName = UIDevice.current.name
    
    static var revenueKey = "appl_yRdsJoVJIbFEANRnXpjmKpPYNSi"
}
// TODO: Test and fix if needed
let genders = ["Male", "Female", "Other"]
let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
let weekDaysL = ["Sun.SHORT", "Mon.SHORT", "Tue.SHORT", "Wed.SHORT", "Thu.SHORT", "Fri.SHORT", "Sat.SHORT"]
let xMonths = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
let xDays = [
    "1", "", "", "", "5", "", "", "", "", "10",
    "", "", "", "", "15", "", "", "", "", "20",
    "", "", "", "", "25", "", "", "", "", "30",
    ""
]
let vibrationTypes: [LocalizedStringKey] = [
    "V.BASIC",
    "V.BASIC",
    "V.SLOW_PULSE",
    "V.HEARTBEAT",
    "V.TICKTOCK",
    "V.ZIG",
    "V.RAPID",
    "V.STACCATO"
]

let qrCodeExpTime: Int = 300
let updatingTime: Int = 300

let languageList: [(loc: String, lang: String, number: Int)] = [("en", "English", 0), ("ko", "한국어", 1), ("ja", "日本語", 2)]
// TODO: localize
let weightList: [String] = ["kg", "punds, lb"]
let heightList: [String] = ["cm", "feet-inches, ft-in"]
let temperatureList: [String] = ["°C", "°F"]
let humidityList: [String] = ["Relative humidity, %RH", "Absolute humidity, g/m³"]
