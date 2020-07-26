//
//  GYNHttpClient.swift
//
//  Created by dyf on 16/2/3. ( https://github.com/dgynfi/GYNFoundation )
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

import Foundation

// Does not include "?" or "/" due to RFC 3986 - Section 3.4
public let GYNCharactersGeneralDelimitersToEncode: String = ":#[]@"
public let GYNCharactersSubDelimitersToEncode: String = "!$&'()*+,;="

/**
 *  Returns a percent-escaped string following RFC 3986 for a query string key or value.
 RFC 3986 states that the following characters are "reserved" characters.
 - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
 - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
 
 In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
 query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
 should be percent-escaped in the query string.
 *
 *  @param str The string to be percent-escaped.
 *
 *  @return The percent-escaped string.
 */
public func GYNPercentEscapedString(from s: String?) -> String? {
    
    guard let arg = s else { return nil }
    
    var allowedCharacterSet = CharacterSet.urlQueryAllowed
    
    var generalDelimiters = GYNCharactersGeneralDelimitersToEncode
    let subDelimiters = GYNCharactersSubDelimitersToEncode
    generalDelimiters.append(subDelimiters)
    
    allowedCharacterSet.remove(charactersIn: generalDelimiters)
    
    let batchSize: Int = 50
    var index: Int = 0
    let tempArg: NSString = arg as NSString
    let escaped: NSMutableString = NSMutableString()
    
    while index < tempArg.length {
        let length: Int = [tempArg.length - index, batchSize].min()!
        
        //let startIndex = arg.index(arg.startIndex, offsetBy: index)
        //let endIndex = arg.index(arg.startIndex, offsetBy: index+length)
        //var range: Range = startIndex..<endIndex
        
        var range: NSRange = NSMakeRange(index, length)
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = tempArg.rangeOfComposedCharacterSequences(for: range)
        
        let substring = tempArg.substring(with: range)
        let encoded: String = substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
        escaped.append(encoded)
        
        //let utf16View = substring.utf16
        //let from = range.lowerBound.samePosition(in: utf16View)
        //let to = range.upperBound.samePosition(in: utf16View)
        //let len: Int = utf16View.distance(from: from!, to: to!)
        let len = range.length
        
        index += len
    }
    
    return escaped as String
}

/// Returns a percent-encoded string. Note: It is suitable for encoding the basic url.
/// - Parameter s: A Unicode string value that is a collection of characters.
public func GYNUrlPercentEncoding(_ s: String?) -> String? {
    guard let _s = s else {
        return nil
    }
    
    let c = CharacterSet.urlQueryAllowed
    
    return _s.addingPercentEncoding(withAllowedCharacters: c)
}

/// Returns a percent-escaped string. Note: It is suitable for encoding paramenters.
/// - Parameter s: A Unicode string value that is a collection of characters.
public func GYNUrlEncode(_ s: String?) -> String? {
    return GYNPercentEscapedString(from: s)
}

/// A new string made from the string by replacing all percent encoded sequences with the matching UTF-8 characters.
/// - Parameter s: A Unicode string value that is a collection of characters.
public func GYNUrlDecode(_ s: String?) -> String? {
    guard let _s = s else { return nil }
    
    let value = _s.removingPercentEncoding
    guard let result = value else {
        return _s
    }
    
    return result
}

/// Converts a `String` to a `Data`.
/// - Parameter s: A Unicode string value that is a collection of characters.
public func GYNToData(withString s: String?) -> Data? {
    return s?.data(using: String.Encoding.utf8)
}

// The HTTP method enum.
public enum HttpMethd: UInt8 {
    case Get = 1, Post, Head, Patch, Put, Delete
}

// The HTTP method for the request, the string is "GET".
public let HttpMethodGET: String    = "GET"
// The HTTP method for the request, the string is "POST".
public let HttpMethodPOST: String   = "POST"
// The HTTP method for the request, the string is "HEAD".
public let HttpMethodHEAD: String   = "HEAD"
// The HTTP method for the request, the string is "PATCH".
public let HttpMethodPATCH: String  = "PATCH"
// The HTTP method for the request, the string is "PUT".
public let HttpMethodPUT: String    = "PUT"
// The HTTP method for the request, the string is "DELETE".
public let HttpMethodDELETE: String = "DELETE"

// The HTTP status code of the receiver.
public let GYNURLNoError = 200

// Returned when an asynchronous operation times out. NSURLSession sends this error to its delegate when the timeoutInterval of an NSURLRequest expires before a load can complete.
public let GYNURLErrorTimeout = NSURLErrorTimedOut

// Returned when a network resource was requested, but an internet connection is not established and cannot be established automatically, either through a lack of connectivity, or by the user's choice not to make a network connection automatically.
public let GYNURLErrorDisconnection = NSURLErrorNotConnectedToInternet

open class GYNHttpClient: NSObject, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    // A value that identifies the location of a resource, such as an item on a remote server or the path to a local file.
    private var url: URL?
    public var method: HttpMethd?
    
    // The request body is sent as the message body of the request, as in an HTTP POST request. Setting the HTTP body data clears any input stream in httpBodyStream. These values are mutually exclusive.
    public var httpBody: Data?
    private var recvData: NSMutableData?
    
    public var acceptLanguage: String?
    // The timeout interval for the request.
    public var timeoutInterval: TimeInterval?
    
    // The content format of the data sent in this request.
    public var contentType: String?
    
    // The acceptable MIME types for responses. When non-`nil`, responses with a `Content-Type` with MIME types that do not intersect with the set will result in an error during validation.
    // e.g.: @"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", @"image/jpeg".
    public var acceptableContentTypes: NSMutableSet?
    
    // An object that coordinates a group of related network data transfer tasks.
    private var urlSession: URLSession?
    // A URL session task that returns downloaded data directly to the app in memory.
    private var dataTask: URLSessionDataTask?
    
    // A closure to be executed when the task finishes. This block has no return value and takes three arguments: the server response, the response object, and the error that occurred, if any.
    private var completionHandler: ((_ response: URLResponse?, _ responseObject: Any?, _ error: NSError?) -> Void)?
    
    // A Boolean value that determines whether connections should be made over a cellular network.
    public var allowsCellularAccess: Bool = true
    
    private let logLabel = "[\((#file as NSString).lastPathComponent):\(#function)]"
    
    public init(url: URL?) {
        self.url = url
        self.method = HttpMethd.Get
        self.acceptLanguage = "zh"
        self.contentType = "application/x-www-form-urlencoded;charset=utf-8"
        self.acceptableContentTypes = ["application/json",
                                       "application/xml",
                                       "text/plain",
                                       "text/json", "text/xml",
                                       "text/html",
                                       "text/javascript",
                                       "image/jpeg", "image/png",
                                       "image/gif"]
        self.timeoutInterval = 15.0
        self.recvData = NSMutableData(capacity: 0)
    }
    
    public convenience init(url: URL?, method: HttpMethd) {
        self.init(url: url)
        self.method = method
    }
    
    open func resume() {
        self.dataTask?.resume()
    }
    
    open func cancel() {
        self.urlSession?.invalidateAndCancel()
    }
    
    open func sendAsyncRequest(_ completionHandler: @escaping (_ response: URLResponse?, _ responseObject: Any?, _ error: NSError?) -> Void) {
        self.completionHandler = completionHandler
        self.execute()
    }
    
    private func execute() {
        self.urlSession = URLSession(configuration: setUpURLSessionConfig(), delegate: self, delegateQueue: nil)
        
        let urlRequest: URLRequest = configureURLRequest()
        self.dataTask = self.urlSession?.dataTask(with: urlRequest)
        
        self.resume()
    }
    
    private func setUpURLSessionConfig() -> URLSessionConfiguration {
        let urlSessionConfig = URLSessionConfiguration.default
        
        urlSessionConfig.requestCachePolicy        = .reloadIgnoringCacheData
        urlSessionConfig.allowsCellularAccess      = allowsCellularAccess
        urlSessionConfig.timeoutIntervalForRequest = timeoutInterval!
        
        return urlSessionConfig
    }
    
    private func configureURLRequest() -> URLRequest {
        let aUrl: URL = self.url ?? URL(string: "")!
        print("\(logLabel) aUrl: \(aUrl)")
        
        var request = URLRequest(url: aUrl)
        
        switch self.method! {
        case .Get:
            request.httpMethod = HttpMethodGET
            break
        case .Post:
            request.httpMethod = HttpMethodPOST
            break
        case .Head:
            request.httpMethod = HttpMethodHEAD
            break
        case .Put:
            request.httpMethod = HttpMethodPUT
            break
        case .Patch:
            request.httpMethod = HttpMethodPATCH
            break
        case .Delete:
            request.httpMethod = HttpMethodDELETE
            break
        }
        
        if self.method! != .Get {
            request.httpBody = self.httpBody
        }
        
        request.setValue(self.contentType, forHTTPHeaderField: "Content-Type")
        request.setValue(acceptableContentValue(), forHTTPHeaderField: "Accept")
        request.setValue(self.acceptLanguage, forHTTPHeaderField: "Accept-Language")
        
        return request
    }
    
    private func acceptableContentValue() -> String {
        var result: String = "";
        //let count: Int = self.acceptableContentTypes!.count;
        
        for (index, value) in self.acceptableContentTypes!.enumerated() {
            let v: String = value as! String
            if index == 0 {
                result += v
            } else {
                result += "," + v
            }
        }
        
        print("\(logLabel) acceptableContentValue: " + result)
        
        return result
    }
    
    private func trustServer(_ challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let protectionSpace = challenge.protectionSpace
        let secTrust = protectionSpace.serverTrust
        
        assert(secTrust != nil)
        
        if secTrust != nil {
            let urlCredential = URLCredential(trust: secTrust!)
            challenge.sender?.use(urlCredential, for: challenge)
            
            completionHandler(.useCredential, urlCredential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    open func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("\(logLabel) didReceive challenge: ")
        let method = challenge.protectionSpace.authenticationMethod
        
        if method == NSURLAuthenticationMethodServerTrust {
            trustServer(challenge, completionHandler: completionHandler);
        }
    }
    
    open func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        // willPerformHTTPRedirection
        print("\(logLabel) willPerformHTTPRedirection response: ")
    }
    
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("\(logLabel) didReceive response: ")
        self.recvData?.length = 0
        let httpUrlResponse = response as! HTTPURLResponse
        
        if httpUrlResponse.statusCode == GYNURLNoError {
            completionHandler(URLSession.ResponseDisposition.allow)
        } else {
            completionHandler(URLSession.ResponseDisposition.cancel)
            
            let error = NSError(domain: self.url?.host ?? "GYN.urlresponse.status",
                                code: httpUrlResponse.statusCode,
                                userInfo: httpUrlResponse.allHeaderFields as? [String : Any])
            self.completionHandler?(response, nil, error);
            self.cancel()
        }
    }
    
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("\(logLabel) didReceive data: ")
        self.recvData?.append(data)
    }
    
    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("\(logLabel) didCompleteWithError error: ")
        
        if error != nil {
            print("\(logLabel) didCompleteWithError error: \(error!) ")
            
            self.recvData?.length = 0
            self.completionHandler?(task.response, nil, error! as NSError)
        } else {
            
            let data = self.recvData?.copy()
            self.completionHandler?(task.response, data, nil)
        }
    }
    
}
