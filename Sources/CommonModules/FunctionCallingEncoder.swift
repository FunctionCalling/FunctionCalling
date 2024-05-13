//
//  FunctionCallingEncoder.swift
//  
//
//  Created by 伊藤史 on 2024/07/29.
//

import Foundation


public enum FunctionCallingEncoder {
    private static let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        return encoder
    }()

    public static func encode(_ value: Encodable) throws -> Data {
        try jsonEncoder.encode(value)
    }
}
