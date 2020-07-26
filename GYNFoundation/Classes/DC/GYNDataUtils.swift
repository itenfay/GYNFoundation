//
//  GYNDataUtils.swift
//
//  Created by dyf on 16/2/15. ( https://github.com/dgynfi/GYNFoundation )
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

class GYNDataUtils: NSObject {
    
    class func imei() -> String {
        let s = idfa()
        
        guard let idfa = s else {
            return GYNEmptyString
        }
        
        return idfa
    }
    
    class func imsi() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    class func deviceID() -> String {
        return GYNDataGA.deviceID()
    }
    
    class func telephoneNumber() -> String {
        return GYNEmptyString
    }
    
    class func resolution() -> String {
        let scale  = UIScreen.main.scale
        let bounds = UIScreen.main.bounds
        let w = scale * bounds.size.width
        let h = scale * bounds.size.height
        return String(format: "%.0fx%.0f", w, h)
    }
    
    class func systemName() -> String {
        return UIDevice.current.systemName
    }
    
    class func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    class func deviceName() -> String {
        return UIDevice.current.name
    }
    
    class func deviceModel() -> String {
        var uts: utsname = utsname()
        uname(&uts)
        let machineMirror = Mirror(reflecting: uts.machine)
        
        let identifier = machineMirror.children.reduce("") {
            (label, element) in
            
            guard let value = element.value as? Int8, value != 0 else {
                return label
            }
            
            return label + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    class func timeStamp() -> Int {
        return GYNUtils.timeStamp()
    }
    
    class func dataTime() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    class func baseData() -> Any {
        let data: NSDictionary = NSMutableDictionary()
        
        data.setValue(GYNEmptyString, forKey: "appId")
        data.setValue(GYNEmptyString, forKey: "cpId")
        data.setValue(GYNEmptyString, forKey: "channelId")
        data.setValue(GYNEmptyString, forKey: "userId")
        data.setValue(GYNEmptyString, forKey: "goodsName")
        data.setValue(GYNEmptyString, forKey: "transId")
        data.setValue(GYNEmptyString, forKey: "num")
        data.setValue(GYNEmptyString, forKey: "eventId")
        data.setValue(GYNEmptyString, forKey: "token")
        data.setValue(GYNEmptyString, forKey: "serverId")
        
        data.setValue(deviceID(), forKey: "deviceId")
        data.setValue(resolution(), forKey: "resolution")
        data.setValue(systemName(), forKey: "os")
        data.setValue(systemVersion(), forKey: "osVersion")
        data.setValue(deviceModel(), forKey: "model")
        data.setValue(imei(), forKey: "imei")
        data.setValue(imsi(), forKey: "imsi")
        data.setValue(telephoneNumber(), forKey: "phoneNum")
        data.setValue(GYNUtils.ipAddress(), forKey: "ip")
        data.setValue(GYNUtils.macAddress(), forKey: "mac")
        data.setValue(dataTime(), forKey: "dataTime")
        
        return data
    }
    
    class func jsonArray(withObject obj: Any) -> String? {
        let array: NSArray = NSArray(object: obj)
        
        let data = try? JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        if let _data = data {
            return String(data: _data, encoding: String.Encoding.utf8)
        }
        
        return nil
    }
    
}
