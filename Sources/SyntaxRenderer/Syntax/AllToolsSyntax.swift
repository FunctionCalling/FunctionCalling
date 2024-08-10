//
//  AllToolsSyntax.swift
//  
//
//  Created by 伊藤史 on 2024/05/24.
//

import Foundation
import Mustache
import CommonModules

/// An enumeration for rendering all tools using a specified template.
enum AllToolsSyntax {
    /// Renders the tools using the given template type.
    /// - Parameters:
    ///   - templateObject: An array of `FunctionTool` objects to be rendered.
    /// - Throws: An error if the rendering fails.
    /// - Returns: A `String` representation of the rendered tools.
    static func render(
        with templateObject: [FunctionTool]
    ) throws -> String {
        return try AllToolsTemplate.render(with: templateObject)
    }
}
