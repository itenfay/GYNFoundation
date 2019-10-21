//
//  FYDHttpUtils.swift
//
//  Created by dyf on 16/2/3.
//  Copyright © 2016 dyf. All rights reserved.
//

import Foundation

// Does not include "?" or "/" due to RFC 3986 - Section 3.4
public let FYDCharactersGeneralDelimitersToEncode: String = ":#[]@"
public let FYDCharactersSubDelimitersToEncode: String = "!$&'()*+,;="

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
public func FYDPercentEscapedString(from arg: String) -> String? {
    var allowedCharacterSet = CharacterSet.urlQueryAllowed
    
    var generalDelimiters = FYDCharactersGeneralDelimitersToEncode
    let subDelimiters = FYDCharactersSubDelimitersToEncode
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

public func FYDUrlEncode(_ arg: String) -> String? {
    return FYDPercentEscapedString(from: arg)
}

public func FYDUrlDecode(_ arg: String) -> String? {
    let _arg: String? = arg.removingPercentEncoding
    return _arg ?? arg.copy() as? String
}

public extension String {
    
    func toNSRange(from range: Range<String.Index>) -> NSRange? {
        let utf16View = self.utf16
        
        if let from = range.lowerBound.samePosition(in: utf16View),
            let to = range.upperBound.samePosition(in: utf16View) {
            return NSMakeRange(utf16View.distance(from: utf16View.startIndex, to: from),
                               utf16View.distance(from: from, to: to))
        }
        
        return nil
    }
    
}

open class FYDHttpUtils: NSObject {
    
    private class func addPercentEncoding(_ string: String) -> String? {
        let urlQueryAllowed = CharacterSet.urlQueryAllowed
        return string.addingPercentEncoding(withAllowedCharacters: urlQueryAllowed)
    }
    
    open class func encodedUrl(_ url: String) -> URL? {
        let encodedUrl = addPercentEncoding(url)
        
        if encodedUrl != nil {
            return URL(string: encodedUrl!)
        }
        
        return nil
    }
    
    open class func decodedUrl(_ url: String) -> String? {
        let decodedUrl: String? = url.removingPercentEncoding
        return decodedUrl ?? url.copy() as? String
    }
    
    open class func toData(withString string: String) -> Data? {
        return string.data(using: String.Encoding.utf8)
    }
    
}

public extension NSString {
    func beginValue(_ value: String, forKey key: String) -> String {
        return self.appending(key + "=" + value)
    }
    
    func addValue(_ value: String, forKey key: String) -> String {
        return self.appending("&" + key + "=" + value)
    }
}
