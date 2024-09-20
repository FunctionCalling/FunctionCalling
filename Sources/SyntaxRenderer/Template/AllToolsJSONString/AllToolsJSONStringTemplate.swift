//
//  AllToolsJSONStringTemplate.swift
//
//
//  Created by 伊藤史 on 2024/05/20.
//

import Foundation
import CommonModules

/// An enumeration for different templates used to render all tools.
enum AllToolsJSONStringTemplate {
    /// Renders the tools using the specified template.
    /// - Parameter templateObject: An array of `Tool` objects to be rendered.
    /// - Parameter service: The `FunctionCallingService` used for the tool container
    /// - Throws: An error if the rendering or encoding fails.
    /// - Returns: A `String` representation of the rendered tools.
    static func render(with templateObject: [FunctionTool], service: FunctionCallingService) throws -> String {
        let tools = try service.encoder.encode(templateObject)
        let jsonString = String(decoding: tools, as: UTF8.self)

        return """
        var allToolsJSONString: String {
            \"""
            \(jsonString.emptyLineRemoved.replacingOccurrences(of: "\n", with: ""))
            \"""
        }
        """
    }
}
