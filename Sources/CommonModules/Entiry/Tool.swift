//
//  Tool.swift
//
//
//  Created by 伊藤史 on 2024/04/29.
//

import Foundation

/// A structure representing a tool
public struct Tool {
    /// The name of the tool.
    public let name: String

    /// A description of the tool.
    public let description: String

    /// The input schema for the tool.
    public let inputSchema: InputSchema

    /// Initializes a new `Tool` instance.
    /// - Parameters:
    ///   - name: The name of the tool.
    ///   - description: A description of the tool.
    ///   - inputSchema: The input schema for the tool.
    public init(name: String, description: String, inputSchema: InputSchema) {
        self.name = name
        self.description = description
        self.inputSchema = inputSchema
    }
}

extension Tool: Encodable {}

extension Tool: Decodable {}
