//
//  FunctionCallingDecoder.swift
//  
//
//  Created by Fumito Ito on 2024/07/31.
//

import Foundation

/// A utility for decoding JSON data with a specific decoding strategy.
enum FunctionCallingDecoder {
    /// A JSON decoder configured to convert keys from snake_case to camelCase.
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
