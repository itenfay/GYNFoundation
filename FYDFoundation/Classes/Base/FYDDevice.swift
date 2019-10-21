//
//  FYDDevice.swift
//
//  Created by dyf on 16/2/16.
//  Copyright © 2016 dyf. All rights reserved.
//

import UIKit
import AdSupport

public func isAdTrackingEnabled() -> Bool {
    // "Build Settings" -> "Swift Compliler-Custom Flags" ->
    // "Other Swift Flags" -> "Debug", add "-D DEBUG"
    // ................... -> “Release”, add "-D FYD_USING_ADSUPPORT"
    // You decides whether to use AdSupport.
#if FYD_USING_ADSUPPORT
    return ASIdentifierManager.shared().isAdvertisingTrackingEnabled
#else
    return false
#endif
}

public func idfa() -> String? {
#if FYD_USING_ADSUPPORT
    return ASIdentifierManager.shared().advertisingIdentifier.uuidString
#else
    return nil
#endif
}

public func idfv() -> String? {
    return UIDevice.current.identifierForVendor?.uuidString
}

open class FYDDevice: NSObject {
    
    private static let kFYDUserName: String = "fyd_device_id"
    private static let kFYDServiceName: String = "fyd_device"
    
    private class func generateUUIDString() -> String {
        var uuid: String? = nil
        
        if #available(iOS 10.0, *) {
            if isAdTrackingEnabled() {
                uuid = idfa() ?? ""
            } else {
                uuid = idfv()
            }
        } else {
            uuid = idfa() ?? idfv()
        }
        
        return uuid!
    }
    
    public class func deleteItem(username: String, serviceName: String) {
        try? SFHFKeychainUtils.deleteItem(forUsername: username, andServiceName: serviceName)
    }
    
    public class func deviceId() -> String {
        var id: String? = try? SFHFKeychainUtils.getPasswordForUsername(kFYDUserName, andServiceName: kFYDServiceName)
        
        if id == nil {
            id = generateUUIDString()
            try? SFHFKeychainUtils.storeUsername(kFYDUserName, andPassword: id!, forServiceName: kFYDServiceName, updateExisting: true)
        }
        
        return id!
    }
}
