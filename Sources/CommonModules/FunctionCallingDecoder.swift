//
//  FunctionCallingDecoder.swift
//  
//
//  Created by Fumito Ito on 2024/07/31.
//

import Foundation

/// A utility for decoding JSON data with a specific decoding strategy.
public enum FunctionCallingDecoder {
    /// A JSON decoder configured to convert keys from snake_case to camelCase.
    private static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    /// Decodes an instance of the specified type from JSON data.
    /// - Parameters:
    ///   - type: The type of the value to decode.
    ///   - data: The JSON data to decode.
    /// - Throws: An error if the data couldn't be decoded into the specified type.
    /// - Returns: An instance of the specified type.
    public static func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        try jsonDecoder.decode(type, from: data)
    }
}
