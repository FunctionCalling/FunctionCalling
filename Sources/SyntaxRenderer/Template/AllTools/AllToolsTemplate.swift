//
//  AllToolsTemplate.swift
//
//
//  Created by 伊藤史 on 2024/05/20.
//

import Foundation
import CommonModules

/// An enumeration for different templates used to render all tools.
enum AllToolsTemplate {
    /// Template for Claude.
    case claude

    /// Initializes an `AllToolsTemplate` based on the given service.
    /// - Parameter service: The `FunctionCallingService` to determine the template.
    init(service: FunctionCallingService) {
        switch service {
        case .claude:
            self = .claude
        }
    }

    /// Renders the tools using the specified template.
    /// - Parameter templateObject: An array of `Tool` objects to be rendered.
    /// - Throws: An error if the rendering or encoding fails.
    /// - Returns: A `String` representation of the rendered tools.
    func render(with templateObject: [Tool]) throws -> String {
        switch self {
        case .claude:
            let tools = try FunctionCallingEncoder.encode(templateObject)
            guard let jsonString = String(data: tools, encoding: .utf8) else {
                throw FunctionCallingError.failedToGetDataFromEncodedTools
            }

            return """
            var allTools: String {
                \"""
                \(jsonString.emptyLineRemoved.replacingOccurrences(of: "\n", with: ""))
                \"""
            }
            """
        }
    }
}
