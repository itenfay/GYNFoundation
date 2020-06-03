//
//  GYNDevice.swift
//
//  Created by dyf on 16/2/16.
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
import AdSupport

public func isAdTrackingEnabled() -> Bool {
    // "Build Settings" -> "Swift Compliler-Custom Flags" ->
    // "Other Swift Flags" -> "Debug", add "-D DEBUG" "-D GYN_USING_ADSUPPORT"
    //                     -> “Release”, add "-D GYN_USING_ADSUPPORT"
    // You decides whether to use AdSupport.
#if GYN_USING_ADSUPPORT
    return ASIdentifierManager.shared().isAdvertisingTrackingEnabled
#else
    return false
#endif
}

public func idfa() -> String? {
#if GYN_USING_ADSUPPORT
    return ASIdentifierManager.shared().advertisingIdentifier.uuidString
#else
    return nil
#endif
}

public func idfv() -> String? {
    return UIDevice.current.identifierForVendor?.uuidString
}

open class GYNDevice: NSObject {
    
    fileprivate static let kGYNUUIDStringStorage: String = "GYNUUIDStringStorageKey"
    
    fileprivate class func generateUUIDString() -> String {
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
        let keychain = DYFSwiftKeychain()
        keychain.delete(kGYNUUIDStringStorage)
    }
    
    public class func deviceID() -> String {
        let keychain = DYFSwiftKeychain()
        
        var id: String? = keychain.get(kGYNUUIDStringStorage)
        
        if id == nil {
            id = generateUUIDString()
            keychain.set(id, forKey:kGYNUUIDStringStorage)
        }
        
        return id!
    }
    
}
