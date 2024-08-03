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
    ///   - templateObject: An array of `Tool` objects to be rendered.
    ///   - templateType: The template type to use for rendering. Default is `.claude`.
    /// - Throws: An error if the rendering fails.
    /// - Returns: A `String` representation of the rendered tools.
    static func render(
        with templateObject: [Tool],
        templateType: AllToolsTemplate = .claude
    ) throws -> String {
        return try templateType.render(with: templateObject)
    }
}
