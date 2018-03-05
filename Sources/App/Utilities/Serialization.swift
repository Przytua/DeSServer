//
//  Serialization.swift
//  App
//
//  Created by Łukasz Przytuła on 04.03.2018.
//

import Foundation

func toData<T>(from value: T) -> Data {
    var value = value
    return withUnsafePointer(to: &value) {
        Data(bytes: $0, count: MemoryLayout<T>.size)
    }
}

func toDictionary(from parameters: String) -> [String: String] {
    var dictionary: [String: String] = [:]
    for param in parameters.split(separator: "&") {
        let nameAndValue = param.split(separator: "=")
        if (nameAndValue.count == 2) {
            let name = nameAndValue[0]
            let value = nameAndValue[1]
            dictionary[String(name)] = String(value)
        }
    }
    
    return dictionary
}
