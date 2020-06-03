//
//  GYNBasicConfiguration.swift
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

open class GYNBasicConfiguration: NSObject {
    
    /// The identifier for a partner.
    open var cpID: String?
    /// The name for a partner.
    open var cpName: String?
    /// The identifier for a app.
    open var appID: String?
    
    /// The name for a app.
    open var appName: String? {
        
        let dic: NSDictionary = Bundle.main.infoDictionary! as NSDictionary
        var name = dic.value(forKey: "CFBundleDisplayName") as? String
        
        if name == nil {
            name = dic.value(forKey: "CFBundleName") as? String
        }
        
        return name
    }
    
    /// The identifier for a channel.
    open var channelID: String?
    /// The identifier for a channel.
    open var channelName: String?
    
    /// The symbol for a currency.
    open var currencyCode: String?
    
    /// The url for notifing a server.
    open var noticeUrl: String?
    /// The identifier for a server.
    open var serverID: String?
}
