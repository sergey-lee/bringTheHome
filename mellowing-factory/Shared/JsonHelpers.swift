//
//  JsonHelpers.swift
//  mellowing-factory
//
//  Created by Florian Topf on 06.01.22.
//

import Foundation

func encodeJson<T: Codable> (data: T) -> Data? {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    do {
        let result = try encoder.encode(data)
        return result
    } catch {
        print("Your encoding sucks \(error)")
        return nil
    }
}

func decodeJson<T: Codable> (data: Data) -> T? {
    let decoder = JSONDecoder()
    
    do {
        let result = try decoder.decode(T.self, from: data)
        return result
    } catch {
        print("Your decoding sucks \(error)")
        return nil
    }
}
