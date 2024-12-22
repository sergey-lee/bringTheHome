//
//  DropdownHelpers.swift
//  mellowing-factory
//
//  Created by Florian Topf on 03.01.22.
//

import Foundation

func getBirthYearOptions() -> [DropdownOption] {
    let minimumAge = 14
    let maximumAge = 100 - minimumAge
    let latestBirthYear = Calendar.current.date(byAdding: .year, value: -minimumAge, to: Date())!
    let earliestBirthYear = Calendar.current.date(byAdding: .year, value: -maximumAge, to: latestBirthYear)!

    return (
        Calendar.current.component(.year, from: earliestBirthYear)..<Calendar.current.component(.year, from: latestBirthYear)
    ).reversed().map {
        DropdownOption(key: UUID().uuidString, value: "\($0)")
    }
}

func getGenderOptions() -> [DropdownOption] {
    return [
        DropdownOption(key: UUID().uuidString, value: "FEMALE"),
        DropdownOption(key: UUID().uuidString, value: "MALE"),
        DropdownOption(key: UUID().uuidString, value: "OTHER"),
    ]
}

func getWeightOptions() -> [DropdownOption] {
    let minimumWeight = 30
    let maximumWeight = 200
    
    return (minimumWeight..<maximumWeight).map {
        DropdownOption(key: UUID().uuidString, value: "\($0)")
    }
}

func getHeightOptions() -> [DropdownOption] {
    let minimumWeight = 120
    let maximumWeight = 220
    
    return (minimumWeight..<maximumWeight).map {
        DropdownOption(key: UUID().uuidString, value: "\($0)")
    }
}

func findOptionByValue<T>(hayStack: [DropdownOption], needle: T?) -> DropdownOption? {
    guard let search = needle else {
        return nil
    }
    
    if let i = hayStack.firstIndex(where: { $0.value == String(describing: search) }) {
        return hayStack[i]
    }
    
    return nil
}


func getBirthYearOptionsInt() -> [Int] {
    let minimumAge = 14
    let maximumAge = 100 - minimumAge
    let latestBirthYear = Calendar.current.date(byAdding: .year, value: -minimumAge, to: Date())!
    let earliestBirthYear = Calendar.current.date(byAdding: .year, value: -maximumAge, to: latestBirthYear)!

    return (
        Calendar.current.component(.year, from: earliestBirthYear)..<Calendar.current.component(.year, from: latestBirthYear)
    ).reversed().map {
        $0
    }
}

func getGenderOptionsInt() -> [Int] {
    return [0, 1, 2]
}

func getWeightOptionsInt(unit: Int) -> [Int] {
    let minimumWeight = 30
    let maximumWeight = 200
    if unit <= 0 {
        return (minimumWeight..<maximumWeight).map { $0 }
    } else {
        let poundMulty = 2.205
        let min = Int(Double(minimumWeight) * poundMulty)
        let max = Int(Double(maximumWeight) * poundMulty)
        return (min..<max).map { $0 }
    }
}

func getHeightOptionsInt() -> [Int] {
    let minimumWeight = 120
    let maximumWeight = 220
    
    return (minimumWeight..<maximumWeight).map { $0 }
}
