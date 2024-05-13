//
//  FunctionCallingDecoder.swift
//  
//
//  Created by Fumito Ito on 2024/07/31.
//

import Foundation

public enum FunctionCallingDecoder {
    private static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }()

    public static func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        try jsonDecoder.decode(type, from: data)
    }
}
