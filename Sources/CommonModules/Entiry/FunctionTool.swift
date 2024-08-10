//
//  FunctionTool.swift
//  
//
//  Created by 伊藤史 on 2024/08/08.
//

import Foundation

/// Type of FunctionTool.
///
/// It's used by only ChatGPT function tools.
public enum FunctionToolType: String, Codable {
    /// `function` type
    case function
    /// There is no type for function
    case none

    /// Initializes a `FunctionToolType` instance from a `FunctionCallingService`.
    /// - Parameter service: The `FunctionCallingService` to initalize from.
    init(fromService service: FunctionCallingService) {
        switch service {
        case .claude:
            self = .none
        case .chatGPT:
            self = .function
        }
    }
}

public struct FunctionTool {
    public let service: FunctionCallingService
    public let type: FunctionToolType
    public let function: Tool

    public init(service: FunctionCallingService, function: Tool) {
        self.service = service
        self.type = FunctionToolType(fromService: service)
        self.function = function
    }

    /// CodingKeys for ChatGPT
    ///
    /// ChatGPT accepts JSON with the following structure.
    /// ```json
    /// [{
    ///  "type": "function",
    ///  "function": { ...(function decralation)... }
    /// }]
    /// ```
    enum ChatGPTCodingKeys: String, CodingKey {
        case type
        case function
    }
}

extension FunctionTool: Encodable {
    public func encode(to encoder: any Encoder) throws {
        switch service {
        case .claude:
            // Anthropic Claude accepts JSON with the following structure.
            // ```json
            // [{
            //   { ...(function decralation)... }
            // }]
            // ```
            var container = encoder.singleValueContainer()
            try container.encode(function)
        case .chatGPT:
            var container = encoder.container(keyedBy: ChatGPTCodingKeys.self)
            try container.encode(type, forKey: .type)
            try container.encode(function, forKey: .function)
        }
    }
}

extension FunctionTool: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: ChatGPTCodingKeys.self)
        if let tool = try? container.decode(Tool.self, forKey: .function) {
            self.service = .chatGPT
            self.type = .function
            self.function = tool
        } else {
            self.service = .claude
            self.type = .none

            let singleValueContainer = try decoder.singleValueContainer()
            self.function = try singleValueContainer.decode(Tool.self)
        }
    }
}
