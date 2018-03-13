//
//  ReplayDataValidator.swift
//  App
//
//  Created by Łukasz Przytuła on 13.03.2018.
//

import Foundation

class ReplayDataValidator {
    
    func validate(replayData: String) -> Bool {
        guard let decoded = Data(base64Encoded: replayData, options: .ignoreUnknownCharacters),
            let uncompressed = try? decoded.gunzipped() else {
                return false
        }
        var posCount: UInt32 = uncompressed[0...3].withUnsafeBytes { $0.pointee }
        posCount = UInt32(bigEndian: posCount)
        let beginning = 12 + (Int(posCount) * 32) + 80
        let end = uncompressed.count
        let playername = String(data: Data(uncompressed[beginning..<end]), encoding: .utf16BigEndian)
        let expectedDataLength = 12 + (Int(posCount) * 32) + (4 * 20) + 34
        return uncompressed.count == expectedDataLength
    }
}
