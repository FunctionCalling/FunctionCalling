//
//  FunctionCallingEncoder.swift
//  
//
//  Created by 伊藤史 on 2024/07/29.
//

import Foundation

/// A utility for encoding Swift values into JSON data with a specific encoding strategy.
public enum FunctionCallingEncoder {
    /// A JSON encoder configured to convert keys from camelCase to snake_case.
    static let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
}
