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
    private static let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    /// Encodes an instance of the specified type to JSON data.
    /// - Parameter value: The value to encode.
    /// - Throws: An error if the value couldn't be encoded to JSON data.
    /// - Returns: The encoded JSON data.
    public static func encode(_ value: Encodable) throws -> Data {
        try jsonEncoder.encode(value)
    }
}
