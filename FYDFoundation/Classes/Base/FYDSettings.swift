//
//  FYDSettings.swift
//
//  Created by dyf on 16/2/16.
//  Copyright © 2016 dyf. All rights reserved.
//

import UIKit

open class FYDSettings: NSObject {
    
    private struct Static {
        static let instance: FYDSettings = FYDSettings()
    }
    
    /// `default`
    open class var `default`: FYDSettings {
        return Static.instance
    }
    
    /// Instantiates a singleton instance.
    ///
    /// - Returns: An `FYDSettings` instance.
    open class func defaultSettings() -> FYDSettings {
        return Static.instance
    }
    
    /// Whether debugging environment.
    public var debug: Bool = false
    /// Whether the logs can be output.
    public var enabledLog: Bool = false
    
    private override init() {
        
    }
}
