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
    /// Renders the tools using the specified template.
    /// - Parameter templateObject: An array of `Tool` objects to be rendered.
    /// - Throws: An error if the rendering or encoding fails.
    /// - Returns: A `String` representation of the rendered tools.
    static func render(with templateObject: [FunctionTool]) throws -> String {
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
