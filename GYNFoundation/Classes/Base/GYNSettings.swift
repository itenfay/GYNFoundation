//
//  GYNSettings.swift
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

open class GYNSettings: NSObject {
    
    /// Struct: Static
    private struct Static {
        static var instance: GYNSettings? = nil
    }
    
    /// `default`
    open class var `default`: GYNSettings {
        
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        guard let instance = Static.instance else {
            let object = GYNSettings()
            Static.instance = object
            return object
        }
        
        return instance
    }
    
    /// Instantiates a singleton instance.
    ///
    /// - Returns: An `GYNSettings` instance.
    open class func defaultSettings() -> GYNSettings {
        return GYNSettings.self.default
    }
    
    /// Whether debugging environment.
    public var debug: Bool = false
    /// Whether the logs can be output.
    public var enabledLog: Bool = false
    
    /// Instantiates an `GYNBasicConfiguration` instance.
    open var basicConf = GYNBasicConfiguration()
    
    private override init() {
        // Override init.
    }
}
