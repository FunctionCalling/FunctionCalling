//
//  ExecuteSyntax.swift
//
//
//  Created by 伊藤史 on 2024/04/30.
//

import Foundation
import Mustache

/// An enumeration for rendering the execution syntax using a specified template.
enum ExecuteSyntax {
    /// Renders the execution syntax using the given template object.
    /// - Parameter templateObject: The `Execute` object to be rendered.
    /// - Throws: An error if the rendering fails.
    /// - Returns: A `String` representation of the rendered execution syntax with empty lines removed.
    static func render(with templateObject: Execute) throws -> String {
        let template = try Template(string: ExecuteTemplate.templateString)
        return try template.render(templateObject).emptyLineRemoved
    }
}
