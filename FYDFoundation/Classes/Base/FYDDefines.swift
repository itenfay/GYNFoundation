//
//  FYDDefines.swift
//
//  Created by dyf on 16/2/17.
//  Copyright © 2016 dyf. All rights reserved.
//

import UIKit

/// Const ----------------------------------------------------

/// Whether to use advertising support.
///public let FYD_USING_ADSUPPORT: Bool = true

/// Enum -----------------------------------------------------

public enum FYDPayResultCode: UInt8 {
    /// The result of Payment is failed.
    case FYDPayResultCodeFailed    = 0
    /// The result of Payment is successful.
    case FYDPayResultCodeSucceeded = 1
    /// The result of Payment is cancelled.
    case FYDPayResultCodeCancelled = 2
    /// The result of Payment is unkown.
    case FYDPayResultCodeUnknown   = 3
}

/// ISO Currency Code ----------------------------------------

/// CNY
public let FYDCHNISOCurrencyCode: String = "CNY"
/// USD
public let FYDUSAISOCurrencyCode: String = "USD"

/// Empty and null string ------------------------------------

/// ""
public let FYDEmptyString: String = ""
/// "null"
public let FYDNullString: String = "null"

/// ----------------------------------------------------------
