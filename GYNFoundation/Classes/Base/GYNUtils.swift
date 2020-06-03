//
//  GYNUtils.swift
//
//  Created by dyf on 16/2/17.
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
import CommonCrypto
import SystemConfiguration.CaptiveNetwork

//----------------------------------------------------------------------------------------

public typealias GYNKVAdapter = NSMutableDictionary

//----------------------------------------------------------------------------------------

public func mainWindow() -> UIWindow {
    
    let sharedApp = UIApplication.shared
    let window = sharedApp.keyWindow ?? sharedApp.windows[0]
    
    return window
}

public func currentViewController() -> UIViewController? {
    
    let viewController = mainWindow().rootViewController
    
    return findCurrentViewController(from: viewController)
}

public func currentView() -> UIView? {
    return currentViewController()?.view
}

fileprivate func findCurrentViewController(from viewController: UIViewController?) -> UIViewController? {
    
    guard var vc = viewController else {
        return nil
    }
    
    while true {
        if let tvc = vc.presentedViewController {
            vc = tvc
        } else if vc.isKind(of: UITabBarController.self) {
            let tbc = vc as! UITabBarController
            if let tvc = tbc.selectedViewController {
                vc = tvc
            }
        } else if vc.isKind(of: UINavigationController.self) {
            let nc = vc as! UINavigationController
            if let tvc = nc.visibleViewController {
                vc = tvc
            }
        } else {
            if vc.children.count > 0 {
                if let tvc = vc.children.last {
                    vc = tvc
                }
            }
            break
        }
    }
    
    return vc
}

public func infoDict() -> NSDictionary {
    return Bundle.main.infoDictionary! as NSDictionary
}

public func appVersion() -> String? {
    return infoDict().value(forKey: "CFBundleShortVersionString") as? String
}

public func bundleVersion() -> String? {
    return infoDict().value(forKey: kCFBundleVersionKey as String) as? String
}

public func appName() -> String? {
    
    let dic: NSDictionary = Bundle.main.infoDictionary! as NSDictionary
    var name: String? = dic.value(forKey: "CFBundleDisplayName") as? String
    
    if name == nil {
        name = dic.value(forKey: "CFBundleName") as? String
    }
    
    return name
}

//----------------------------------------------------------------------------------------

public struct GYNUtils {
    
    /// timestamp
    public static func timeStamp() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    /// MD5
    public static func md5(_ arg: String) -> String? {
        return arg.md5
    }
    
    /// IP Address.
    public static func ipAddress() -> String? {
        
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            
            // For each interface ...
            while ptr != nil {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname,
                                        socklen_t(hostname.count),
                                        nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8: hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                
                ptr = ptr!.pointee.ifa_next
            }
            
            freeifaddrs(ifaddr)
        }
        
        print("Local IP \(addresses)")
        
        return addresses.first
    }
    
    /// Mac Address.
    public static func macAddress() -> String {
        
        let index = Int32(if_nametoindex("en0"))
        let bsdData = "en0".data(using: String.Encoding.utf8)
        var mib: [Int32] = [CTL_NET, AF_ROUTE, 0, AF_LINK, NET_RT_IFLIST, index]
        var len = 0
        
        if mib[5] == 0 {
            print("Error: if_nametoindex error.")
            return "00:00:00:00:00:00"
        }
        
        if sysctl(&mib, UInt32(mib.count), nil, &len, nil, 0) < 0 {
            print("Error: could not determine length of info data structure.")
            return "00:00:00:00:00:00"
        }
        
        var buffer = [CChar](repeating: 0, count: len)
        if sysctl(&mib, UInt32(mib.count), &buffer, &len, nil, 0) < 0 {
            print("Error: could not read info data structure.");
            return "00:00:00:00:00:00"
        }
        
        let infoData: NSData = NSData(bytes: buffer, length: len)
        //var interfaceMsgStruct = if_msghdr()
        //infoData.getBytes(&interfaceMsgStruct, length: 1000)
        
        let socketStructStart = 1
        let socketStructData = NSData(data: infoData.subdata(with: NSMakeRange(socketStructStart, len - socketStructStart)))
        let rangeOfToken = socketStructData.range(of: bsdData!, options: NSData.SearchOptions(rawValue: 0), in: NSMakeRange(0, socketStructData.count))
        
        let macAddressData = NSData(data: socketStructData.subdata(with: NSMakeRange(rangeOfToken.location + 3, 6)))
        var macAddressDataBytes = [UInt8](repeating: 0, count: 6)
        macAddressData.getBytes(&macAddressDataBytes, length: 6)
        
        return macAddressDataBytes.map({ String(format:"%02x", $0) }).joined(separator: ":")
    }
    
    public static func ssid() -> String? {
        
        let interfaces: NSArray = CNCopySupportedInterfaces()!
        var ssid: String? = nil
        
        for sub in interfaces {
            if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(sub as! CFString)) {
                ssid = dict["SSID"] as? String
            }
        }
        
        return ssid
    }
    
    public static func wifiMac() -> String? {
        
        let interfaces: NSArray = CNCopySupportedInterfaces()!
        var mac: String? = nil
        
        for sub in interfaces {
            if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(sub as! CFString)) {
                mac = dict["BSSID"] as? String
            }
        }
        
        return mac
    }
    
    public static func adapter() -> GYNKVAdapter {
        return GYNKVAdapter()
    }
    
    public static func number(withInt int: Int32) -> NSNumber {
        return NSNumber(value: int)
    }
    
    public static func number(withBool bool: Bool) -> NSNumber {
        return NSNumber(value: bool)
    }
    
    public static func number(withFloat float: Float) -> NSNumber {
        return NSNumber(value: float)
    }
    
    public static func number(withDouble double: Double) -> NSNumber {
        return NSNumber(value: double)
    }
    
    public static func json(withObject object: Any?) -> String? {
        
        guard let obj = object else { return nil }
        
        let data = try? JSONSerialization.data(withJSONObject: obj)
        if let _data = data {
            return String(data: _data, encoding: String.Encoding.utf8)
        }
        
        return nil
    }
    
    public static func object(withJson json: String?) -> Any? {
        
        guard let s = json else { return nil }
        
        if JSONSerialization.isValidJSONObject(s) {
            
            let data = s.data(using: String.Encoding.utf8)
            
            if let _data = data {
                let obj = try? JSONSerialization.jsonObject(with: _data)
                return obj
            }
        }
        
        return nil
    }
    
    public static func bundlePath(withName name: String?) -> String? {
        
        let path = Bundle.main.path(forResource: name, ofType: kBundleExtension)
        
        // let url = Bundle.main.url(forResource: bundleName, withExtension: kBundleExtension)
        // guard let anUrl = url else {
        //    return nil
        // }
        // let path = Bundle(url: anUrl)?.bundlePath
        
        return path
    }
    
    public static func defaultFilePath() -> String {
        
        let path = self.bundlePath(withName: kDefaultBundleName)
        
        return (path ?? "") + "/" + kDefaultFileDirName + "/" + kDefaultFileName
    }
}

//----------------------------------------------------------------------------------------

public extension String {
    
    var md5: String? {
        let cStr = self.cString(using: String.Encoding.utf8)
        
        if cStr != nil {
            let digestLen = Int(CC_MD5_DIGEST_LENGTH)
            let strLen = (CC_LONG)(self.lengthOfBytes(using: String.Encoding.utf8))
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)
            
            CC_MD5(cStr!, strLen, buffer) // (CC_LONG)(strlen(cStr!))
            
            let result = NSMutableString()
            for i in 0..<digestLen {
                result.appendFormat("%02x", buffer[i])
            }
            
            free(buffer)
            
            return result as String
        }
        
        return nil
    }
}

//----------------------------------------------------------------------------------------
