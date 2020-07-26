//
//  GYNLogger.swift
//
//  Created by dyf on 16/2/16. ( https://github.com/dgynfi/GYNFoundation )
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

/// Output the logs to the console.
///
/// - Parameters:
///   - format: The format string.
///   - args: The args to be output.
public func GYNLog(_ format: String, _ args: CVarArg...) {
    
    if GYNSettings.defaultSettings().enabledLog {
        let output = String(format: format, arguments: args)
        print("[GYN]:" + " " + output)
    }
    
}

open class GYNLogger: NSObject {
    
    /// Output the logs to the console.
    ///
    /// - Parameters:
    ///   - format: The format string.
    ///   - args: The args to be output.
    open class func log(_ format: String, _ args: CVarArg...) {
        
        if GYNSettings.defaultSettings().enabledLog {
            let output = String(format: format, arguments: args)
            print("[GYN]:" + " " + output)
        }
    }
    
}
