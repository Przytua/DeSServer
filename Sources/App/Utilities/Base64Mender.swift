//
//  Base64Mender.swift
//  App
//
//  Created by Łukasz Przytuła on 13.03.2018.
//

import Foundation

class Base64Mender {
    
    func fix(replayData: String) -> String {
        var fixedReplayData = ""
        for c in replayData {
            if "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz/+".contains(c) {
                fixedReplayData += String(c)
            } else if c == " " {
                fixedReplayData += "+"
            } else {
                break
            }
        }
        
        if fixedReplayData.count % 4 == 3 {
            return fixedReplayData + "="
        } else if fixedReplayData.count % 4 == 2 {
            return fixedReplayData + "=="
        } else if fixedReplayData.count % 4 == 1 {
            return fixedReplayData + "A=="
        }
        return fixedReplayData
    }
}
