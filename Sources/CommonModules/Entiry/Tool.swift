//
//  Tool.swift
//
//
//  Created by 伊藤史 on 2024/04/29.
//

import Foundation

/// A structure representing a tool
public struct Tool {
    /// The service to use
    public let service: FunctionCallingService

    /// The name of the tool.
    public let name: String

    /// A description of the tool.
    public let description: String

    /// The input schema for the tool.
    public let inputSchema: InputSchema

    /// Initializes a new `Tool` instance.
    /// - Parameters:
    ///   - service: The service to use.
    ///   - name: The name of the tool.
    ///   - description: A description of the tool.
    ///   - inputSchema: The input schema for the tool.
    public init(service: FunctionCallingService, name: String, description: String, inputSchema: InputSchema) {
        self.service = service
        self.name = name
        self.description = description
        self.inputSchema = inputSchema
    }

    /// CodingKeys for Anthropic Claude
    ///
    /// Anthropic Claude accepts JSON with the following structure.
    /// ```json
    /// {
    ///  "name": "function",
    ///  "description": "",
    ///  "input_schema": { ...(json schema for input parameters)... }
    /// }
    /// ```
    enum ClaudeCodingKeys: String, CodingKey {
        case name
        case description
        case inputSchema
    }

    /// CodingKeys for ChatGPT
    ///
    /// ChatGPT accepts JSON with the following structure.
    /// ```json
    /// {
    ///  "name": "function",
    ///  "strict": true,
    ///  "description": "",
    ///  "parameters": { ...(json schema for input parameters)... }
    /// }
    /// ```
    enum ChatGPTCodingKeys: String, CodingKey {
        case name
        case strict
        case description
        case parameters
    }

    /// CodingKeys for Llama API
    ///
    /// Llama API accepts JSON with the following structure.
    /// ```json
    /// {
    ///  "name": "function",
    ///  "description": "",
    ///  "parameters": { ...(json schema for input parameters)... }
    /// }
    /// ```
    enum LlamaCodingKeys: String, CodingKey {
        case name
        case description
        case parameters
    }
}

extension Tool: Encodable {
    public func encode(to encoder: any Encoder) throws {
        switch service {
        case .claude:
            var container = encoder.container(keyedBy: ClaudeCodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(description, forKey: .description)
            try container.encode(inputSchema, forKey: .inputSchema)
        case .chatGPT:
            var container = encoder.container(keyedBy: ChatGPTCodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(true, forKey: .strict)
            try container.encode(description, forKey: .description)
            try container.encode(inputSchema, forKey: .parameters)
        case .llamaOrGemini:
            var container = encoder.container(keyedBy: LlamaCodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(description, forKey: .description)
            try container.encode(inputSchema, forKey: .parameters)
        }
    }
}

extension Tool: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: ClaudeCodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)

        if let inputSchema = try container.decodeIfPresent(InputSchema.self, forKey: .inputSchema) {
            self.service = .claude
            self.inputSchema = inputSchema
        } else {
            let chatGPTContainer = try decoder.container(keyedBy: ChatGPTCodingKeys.self)
            if let _ = try? chatGPTContainer.decode(Bool.self, forKey: .strict) {
                self.service = .chatGPT
            } else {
                self.service = .llamaOrGemini
            }
            self.inputSchema = try chatGPTContainer.decode(InputSchema.self, forKey: .parameters)
        }
    }
}
