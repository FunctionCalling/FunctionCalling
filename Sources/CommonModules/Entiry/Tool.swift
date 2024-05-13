//
//  Tool.swift
//
//
//  Created by 伊藤史 on 2024/04/29.
//

import Foundation

public struct Tool {
    public let name: String
    public let description: String
    public let inputSchema: InputSchema

    public init(name: String, description: String, inputSchema: InputSchema) {
        self.name = name
        self.description = description
        self.inputSchema = inputSchema
    }
}

extension Tool: Encodable {}

extension Tool: Decodable {}
