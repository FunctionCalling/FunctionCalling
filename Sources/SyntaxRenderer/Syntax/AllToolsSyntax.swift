//
//  AllToolsSyntax.swift
//  FunctionCalling
//
//  Created by 伊藤史 on 2024/09/20.
//

import CommonModules

/// An enumeration for rendering all tools.
enum AllToolsSyntax {
    /// Renders the string to convert json string into `[Tool]`.
    /// - Returns: A `String` representation of the rendered tools.
    static func render() -> String {
        return AllToolsTemplate.render()
    }
}
