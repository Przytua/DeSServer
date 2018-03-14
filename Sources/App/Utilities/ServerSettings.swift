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
    }
    
    var worldTendency: Data? {
        get {
            guard let worldTendencyValue = (try? ServerSetting.makeQuery().filter("key", .equals, ServerSettings.Keys.worldTendency).first()?.value) as? String else {
                return nil
            }
            return Data(base64Encoded: worldTendencyValue)
        }
        set {
            guard let newValue = newValue else {
                return
            }
            let newWorldTendencyValue = newValue.base64EncodedString()
            var worldTendencySetting = (try? ServerSetting.makeQuery().filter("key", .equals, ServerSettings.Keys.worldTendency).first()) as? ServerSetting
            if worldTendencySetting == nil {
                worldTendencySetting = ServerSetting(key: ServerSettings.Keys.worldTendency)
            }
            worldTendencySetting!.value = newWorldTendencyValue
            try? worldTendencySetting!.save()
        }
    }
}
