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
        guard let index = param.index(of: "=") else {
            continue
        }
        let name = String(param[param.startIndex..<index])
        let value = String(param[param.index(after: index)..<param.endIndex])
        dictionary[name] = normalizeValue(value, parameterName: name)
    }
    
    return dictionary
}

func normalizeValue(_ value: String, parameterName: String) -> String {
    guard parameterName == "blockID" || parameterName == "ghostBlockID" else {
        return value
    }
    let blockID = Int64(value)!
    if blockID > (1 << 31) {
        return String(blockID - (1 << 32))
    }
    return value
}
