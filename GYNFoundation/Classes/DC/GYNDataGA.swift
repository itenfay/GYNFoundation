//
//  GYNDataGA.swift
//
//  Created by dyf on 16/2/4. ( https://github.com/dgynfi/GYNFoundation )
//  Copyright © 2016 dyf. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

public enum GYNDataGAEventID: UInt8 {
    /// Register Event Identifier.
    case register = 1
    /// LogIn Event Identifier.
    case login = 2
    /// Pay Event Identifier.
    case pay = 3
    /// Launch Event Identifier.
    case launch = 4
    /// Suspend Event Identifier.
    case suspend = 11
    /// Activate Event Identifier.
    case activate = 12
    /// Logout Event Identifier.
    case logout = 13
}

open class GYNDataGA: NSObject {
    
    open class func setDebugMode(_ mode: Bool) {
        GYNData.shared.debug = mode
    }
    
    open class func setEnabledLog(_ enabled: Bool) {
        GYNData.shared.enabledLog = enabled
    }
    
    open class func setStatKey(_ key: String) {
        GYNData.shared.statKey = key
    }
    
    open class func setUrl(_ url: String?) {
        GYNData.shared.url = url
    }
    
    open class func setDeviceID(_ id: String) {
        GYNData.shared.uuid = id
    }
    
    open class func deviceID() -> String {
        return GYNData.shared.uuid!
    }
    
    open class func setBeginTime(_ time: Int) {
        GYNData.shared.beginTime = time
    }
    
    open class func beginTime() -> Int {
        return GYNData.shared.beginTime
    }
    
    open class func setUid(_ uid: String?) {
        GYNData.shared.uid = uid
    }
    
    open class func setLoginStatus(_ status: Bool) {
        GYNData.shared.loginStatus = status
    }
    
    open class func onTrack(eventID id: GYNDataGAEventID, data collectedData: NSMutableDictionary?) {
        GYNData.shared.collectedData = collectedData
        GYNData.shared.onTrack(eventID: id.rawValue)
    }
    
}
