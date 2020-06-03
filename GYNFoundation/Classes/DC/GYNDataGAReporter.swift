//
//  GYNDataGAReporter.swift
//
//  Created by dyf on 16/2/15.
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

protocol GYNDataGAReporterDelegate {
    /// When the received data is completed or an error occurs, execute this callback method.
    ///
    /// - Parameters:
    ///   - reporter: An `GYNDataGAReporter` instance.
    ///   - error: An `NSError` instance.
    func onResponse(reporter: GYNDataGAReporter, error: NSError?)
}

class GYNDataGAReporter: NSObject {
    
    /// The delegate for reporting data.
    var delegate: GYNDataGAReporterDelegate?
    
    /// The identifier for the event.
    var eventID: UInt8 = 0
    /// The successful status code.
    private let OK_CODE = 2_000
    
    /// Reporting the data.
    ///
    /// - Parameters:
    ///   - url: url
    ///   - args: args
    func report(url: String, args: String) {
        
        let anURL = URL(string: GYNUrlPercentEncoding(url) ?? "")
        let httpClient = GYNHttpClient(url: anURL, method: .Post)
        httpClient.httpBody = GYNToData(withString: args)
        
        httpClient.sendAsyncRequest {
            (response: URLResponse?,
            responseObject: Any?,
            error: NSError?) in
            
            let httpUrlResponse = response as? HTTPURLResponse
            
            if let ur = httpUrlResponse, ur.statusCode == GYNURLNoError {
                
                if responseObject != nil {
                    
                    let dict = try? JSONSerialization.jsonObject(with: responseObject as! Data) as? NSDictionary
                    
                    let respCode = dict?.value(forKey: "resultCode") as? Int
                    if let code = respCode, code == self.OK_CODE {
                        
                        self.delegate?.onResponse(reporter: self, error: nil)
                        
                    } else {
                        
                        let info = ["Message": "An error occurred or the parameters is missing."]
                        let err = NSError(domain: "ff.repo.err", code: -self.OK_CODE, userInfo: info)
                        self.delegate?.onResponse(reporter: self, error: err)
                    }
                }
                
            } else {
                
                self.delegate?.onResponse(reporter: self, error: error)
            }
        }
        
    }
    
}
