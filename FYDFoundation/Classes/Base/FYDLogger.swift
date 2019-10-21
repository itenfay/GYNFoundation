//
//  FYDLogger.swift
//
//  Created by dyf on 16/2/16.
//  Copyright © 2016 dyf. All rights reserved.
//

import UIKit

/// Output the logs to the console.
///
/// - Parameters:
///   - format: The format string.
///   - args: The args to be output.
public func FYDLog(_ format: String, _ args: CVarArg...) {
    if FYDSettings.defaultSettings().enabledLog {
        let output: String = String(format: format, arguments: args)
        print("[FYD]: " + " " + output)
    }
}

open class FYDLogger: NSObject {
    
    /// Output the logs to the console.
    ///
    /// - Parameters:
    ///   - format: The format string.
    ///   - args: The args to be output.
    open class func log(_ format: String, _ args: CVarArg...) {
        if FYDSettings.defaultSettings().enabledLog {
            let output: String = String(format: format, arguments: args)
            print("[FYD]: " + " " + output)
        }
    }
    
}
