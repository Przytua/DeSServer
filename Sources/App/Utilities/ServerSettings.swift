//
//  ServerSetting.swift
//  App
//
//  Created by Łukasz Przytuła on 14.03.2018.
//

import Foundation

class ServerSettings {
    
    struct Keys {
        static let worldTendency = "worldTendency"
        static let welcomeMessage = "welcomeMessage"
    }
    
    private var _welcomeMessage: String?
    var welcomeMessage: String {
        get {
            guard let welcomeMessageValue = value(forKey: ServerSettings.Keys.welcomeMessage) else {
                return "The true Demon's Souls starts here!"
            }
            return welcomeMessageValue
        }
        set {
            set(value: newValue, forKey: ServerSettings.Keys.welcomeMessage)
        }
    }
    
    var worldTendency: Data? {
        get {
            guard let worldTendencyValue = value(forKey: ServerSettings.Keys.worldTendency),
            let worldTendency = Data(base64Encoded: worldTendencyValue) else {
                return nil
            }
            return worldTendency
        }
        set {
            guard let newWorldTendencyValue = newValue?.base64EncodedString() else {
                return
            }
            set(value: newWorldTendencyValue, forKey: ServerSettings.Keys.worldTendency)
        }
    }
    
    private func value(forKey key: String) -> String? {
        return (try? ServerSetting.makeQuery().filter("key", .equals, key).first()?.value) as? String
    }
    
    private func set(value: String, forKey key: String) {
        var setting = (try? ServerSetting.makeQuery().filter("key", .equals, key).first()) as? ServerSetting
        if setting == nil {
            setting = ServerSetting(key: key)
        }
        setting!.value = value
        try? setting!.save()
    }
}
