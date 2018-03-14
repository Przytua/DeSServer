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
        static let crossRegionMatchmaking = "crossRegionMatchmaking"
        static let welcomeMessage = "welcomeMessage"
    }
    
    private var _worldTendency: Data?
    var worldTendency: Data {
        get {
            if let worldTendency = _worldTendency {
                return worldTendency
            }
            guard let worldTendencyValue = value(forKey: ServerSettings.Keys.worldTendency) else {
                _worldTendency = Data()
                return _worldTendency!
            }
            _worldTendency = Data(base64Encoded: worldTendencyValue)
            return _worldTendency!
        }
        set {
            _worldTendency = newValue
            let newWorldTendencyValue = newValue.base64EncodedString()
            set(value: newWorldTendencyValue, forKey: ServerSettings.Keys.worldTendency)
        }
    }
    
    private var _crossRegionMatchmaking: Bool?
    var crossRegionMatchmaking: Bool {
        get {
            if let crossRegionMatchmaking = _crossRegionMatchmaking {
                return crossRegionMatchmaking
            }
            guard let crossRegionMatchmakingValue = value(forKey: ServerSettings.Keys.crossRegionMatchmaking) else {
                _crossRegionMatchmaking = false
                return _crossRegionMatchmaking!
            }
            _crossRegionMatchmaking = Bool(crossRegionMatchmakingValue)!
            return _crossRegionMatchmaking!
        }
        set {
            _crossRegionMatchmaking = newValue
            let newCrossRegionMatchmakingValue = newValue.string
            set(value: newCrossRegionMatchmakingValue, forKey: ServerSettings.Keys.crossRegionMatchmaking)
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
