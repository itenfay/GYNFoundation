//
//  FYDFetcher.swift
//
//  Created by dyf on 16/2/16.
//  Copyright © 2016 dyf. All rights reserved.
//

import UIKit

/// The name for the specified directory.
public let kDefaultFileDirName: String = "Files"
/// The name for the specified file.
public let kDefaultFileName: String = "conf.plist"
/// The name for for a bundle.
public let kDefaultBundleName: String = "FYDFoundation"
/// The extension for the bundle.
public let kBundleExtension: String = "bundle"

open class FYDFetcher: NSObject {
    
    /// The `default` fetcher.
    public class var `default`: FYDFetcher {
        struct Static {
            static let instance: FYDFetcher = FYDFetcher()
        }
        return Static.instance
    }
    
    private override init() {
        
    }
    
    private func bundlePath(bundleName: String) -> String? {
        let bundleUrl: URL = Bundle.main.url(forResource: bundleName, withExtension: kBundleExtension)!
        return Bundle(url: bundleUrl)?.bundlePath
    }
    
    private func filePath(filename: String, subpath path: String) -> String {
        return self.bundlePath(bundleName: filename) ?? "" + "/" + path
    }
    
    public func path(forResource bundleName: String?, subpath path: String) -> String? {
        if bundleName != nil {
            return self.filePath(filename: bundleName!, subpath: path)
        } else {
            return Bundle.main.path(forResource: path, ofType: nil)
        }
    }
    
    public func specifiedFileInfo() -> NSDictionary? {
        let path: String = kDefaultFileDirName + "/" + kDefaultFileName
        return self.infoDict(bundleName: kDefaultBundleName, subpath: path)
    }
    
    public func infoDict(bundleName name: String?, subpath path: String) -> NSDictionary? {
        let filePath: String? = self.path(forResource: name, subpath: path)
        if filePath != nil {
            return NSDictionary(contentsOfFile: filePath!)
        }
        return nil
    }
    
}
