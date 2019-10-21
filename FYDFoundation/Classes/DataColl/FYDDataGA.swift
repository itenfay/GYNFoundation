//
//  FYDDataGA.swift
//
//  Created by dyf on 16/2/4.
//  Copyright © 2016 dyf. All rights reserved.
//

import UIKit

public enum FYDDataGAEventId: UInt8 {
    /// Register Event Identifier.
    case FYD_GA_Event_Register = 1
    /// LogIn Event Identifier.
    case FYD_GA_Event_Login    = 2
    /// Pay Event Identifier.
    case FYD_GA_Event_Pay      = 3
    /// Launch Event Identifier.
    case FYD_GA_Event_Launch   = 4
    /// Suspend Event Identifier.
    case FYD_GA_Event_Suspend  = 11
    /// Activate Event Identifier.
    case FYD_GA_Event_Activate = 12
    /// Logout Event Identifier.
    case FYD_GA_Event_Logout   = 13
}

open class FYDDataGA: NSObject {
    
    open class func onDebugMode(_ mode: Bool) {
        FYDData.shared.debug = mode
    }
    
    open class func onEnableLog(_ enabled: Bool) {
        FYDData.shared.enabledLog = enabled
    }
    
    open class func setStatKey(_ key: String) {
        FYDData.shared.statKey = key
    }
    
    open class func setUrl(_ url: String?) {
        FYDData.shared.url = url
    }
    
    open class func setDeviceId(_ deviceId: String) {
        FYDData.shared.udid = deviceId
    }
    
    open class func deviceId() -> String {
        return FYDData.shared.udid!
    }
    
    open class func setBeginTime(_ time: Int) {
        FYDData.shared.beginTime = time
    }
    
    open class func beginTime() -> Int {
        return FYDData.shared.beginTime
    }
    
    open class func setUid(_ uid: String?) {
        FYDData.shared.uid = uid
    }
    
    open class func setLoginStatus(_ status: Bool) {
        FYDData.shared.loginStatus = status
    }
    
    open class func onTrack(eventId id: UInt8, data collectData: NSMutableDictionary?) {
        FYDData.shared.collectData = collectData
        FYDData.shared.onTrack(eventId: id)
    }
    
}
