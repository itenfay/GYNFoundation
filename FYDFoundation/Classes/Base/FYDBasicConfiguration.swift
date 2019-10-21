//
//  FYDBasicConfiguration.swift
//
//  Created by dyf on 16/2/16.
//  Copyright © 2016 dyf. All rights reserved.
//

import UIKit

open class FYDBasicConfiguration: NSObject {
    
    /// `default`
    open class var `default`: FYDBasicConfiguration {
        struct Static {
            static let instance = FYDBasicConfiguration()
        }
        return Static.instance
    }
    
    /// The identifier for a partner.
    open var cpId: String?
    /// The name for a partner.
    open var cpName: String?
    /// The identifier for a app.
    open var appId: String?
    
    /// The name for a app.
    open var appName: String? {
        let dic: NSDictionary = Bundle.main.infoDictionary! as NSDictionary
        var name: String? = dic.value(forKey: "CFBundleDisplayName") as? String
        
        if name == nil {
            name = dic.value(forKey: "CFBundleName") as? String
        }
        
        return name
    }
    
    /// The identifier for a channel.
    open var channelId: String?
    /// The identifier for a channel.
    open var channelName: String?
    
    /// The symbol for a currency.
    open var currencyCode: String?
    
    /// The url for notifing a server.
    open var notifyURL: String?
    /// The identifier for a server.
    open var serverId: String?
}
