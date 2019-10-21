//
//  FYDDataGAReporter.swift
//
//  Created by dyf on 16/2/15.
//  Copyright © 2016 dyf. All rights reserved.
//

import UIKit

protocol FYDDataGAReporterDelegate {
    /// When the received data is completed or an error occurs, execute this callback method.
    ///
    /// - Parameters:
    ///   - reporter: An `FYDDataGAReporter` instance.
    ///   - error: An `NSError` instance.
    func onResponse(reporter: FYDDataGAReporter, error: NSError?)
}

class FYDDataGAReporter: NSObject {
    
    /// The delegate for reporting data.
    var delegate: FYDDataGAReporterDelegate?
    
    /// The identifier for the event.
    var eventId: UInt8 = 0
    /// The successful status code.
    private let okCode = 2_000
    
    /// Reporting the data.
    ///
    /// - Parameters:
    ///   - url: url
    ///   - args: args
    func report(url: String, args: String) {
        
        let aURL: URL? = FYDHttpUtils.encodedUrl(url)
        let httpClient = FYDHttpClient(url: aURL, method: .Post)
        httpClient.httpBody = FYDHttpUtils.toData(withString: args)
        
        httpClient.sendAsyncRequest {
            (response: URLResponse?,
            responseObject: Any?,
            error: NSError?) in
            
            let httpUrlResponse = response as? HTTPURLResponse
            
            if let r = httpUrlResponse, r.statusCode == FYDURLNoError {
                
                if responseObject != nil {
                    let dict: NSDictionary? = try? JSONSerialization.jsonObject(with: responseObject as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                    let respCode: Int = dict?.value(forKey: "resultCode") as! Int
                    
                    if respCode == self.okCode {
                        self.delegate?.onResponse(reporter: self, error: nil)
                    }
                }
                
            } else {
                
                self.delegate?.onResponse(reporter: self, error: error)
            }
        }
        
    }
    
}
