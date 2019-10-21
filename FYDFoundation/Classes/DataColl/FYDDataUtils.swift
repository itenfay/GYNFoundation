//
//  FYDDataUtils.swift
//
//  Created by dyf on 16/2/15.
//  Copyright © 2016 dyf. All rights reserved.
//

import UIKit

class FYDDataUtils: NSObject {
    
    class func imei() -> String {
        let id: String? = idfa()
        if id != nil {
            return id!
        }
        return FYDEmptyString
    }
    
    class func imsi() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    class func deviceId() -> String {
        return FYDDevice.deviceId()
    }
    
    class func telenumber() -> String {
        return FYDEmptyString
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
        return FYDUtils.timeStamp()
    }
    
    class func dataTime() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    class func baseData() -> Any {
        let data: NSDictionary = NSMutableDictionary()
        
        data.setValue(FYDEmptyString, forKey: "appId")
        data.setValue(FYDEmptyString, forKey: "cpId")
        data.setValue(FYDEmptyString, forKey: "channelId")
        data.setValue(FYDEmptyString, forKey: "userId")
        data.setValue(FYDEmptyString, forKey: "goodsName")
        data.setValue(FYDEmptyString, forKey: "transId")
        data.setValue(FYDEmptyString, forKey: "num")
        data.setValue(FYDEmptyString, forKey: "eventId")
        data.setValue(FYDEmptyString, forKey: "token")
        data.setValue(FYDEmptyString, forKey: "serverId")
        
        data.setValue(deviceId(),            forKey: "deviceId")
        data.setValue(resolution(),          forKey: "resolution")
        data.setValue(systemName(),          forKey: "os")
        data.setValue(systemVersion(),       forKey: "osVersion")
        data.setValue(deviceModel(),         forKey: "model")
        data.setValue(imei(),                forKey: "imei")
        data.setValue(imsi(),                forKey: "imsi")
        data.setValue(telenumber(),          forKey: "phoneNum")
        data.setValue(FYDUtils.ipAddress(),  forKey: "ip")
        data.setValue(FYDUtils.macAddress(), forKey: "mac")
        data.setValue(dataTime(),            forKey: "dataTime")
        
        return data
    }
    
    class func jsonArray(withObject obj: Any) -> String? {
        let array: NSArray = NSArray(object: obj)
        let data = try? JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted)
        if data != nil {
            return String(data: data!, encoding: String.Encoding.utf8)
        }
        return nil
    }
    
}
