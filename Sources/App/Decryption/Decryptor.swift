//
//  Decryptor.swift
//  Run
//
//  Created by Łukasz Przytuła on 01.03.2018.
//

import Foundation
import CryptoSwift

let desKey: [UInt8] = Array("11111111222222223333333344444444".utf8)

class Decryptor {
    
    private static var sharedDecryptor: Decryptor = {
        let networkManager = Decryptor()
        return networkManager
    }()
    
    class var sharedInstance: Decryptor {
        get {
            return sharedDecryptor
        }
    }
    
    func decrypt(_ message: Bytes) -> String? {
        guard message.count > 16 else {
            return nil
        }
        let content = message[16 ..< message.count]
        let iv = message[0 ..< 16]
        
        do {
            var aes: AES
            aes = try AES(key: desKey, blockMode: .CBC(iv: Array(iv)), padding: .noPadding)
            let decrypted = try aes.decrypt(content)
            let data = Data(bytes: decrypted)
            return String(data: data, encoding: .ascii)
        } catch let error {
            print("\(error)\n\n")
        }
        return nil
    }
}
