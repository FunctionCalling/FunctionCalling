//
//  AllToolsTemplate.swift
//  FunctionCalling
//
//  Created by 伊藤史 on 2024/09/20.
//

import CommonModules

/// An enumeration for different templates used to render all `[Tool]` from json string.
enum AllToolsTemplate {
    /// Renders the converting logics from json string to `[Tool]`.
    /// - Returns: A `String` representation of the rendered tools.
    static func render() -> String {
        return """
        var allTools: [Tool]? {
            guard let data = allToolsJSONString.replacingOccurrences(of: "\\n", with: "").data(using: .utf8) else {
                return nil
            }

            return try? service.decoder.decode([Tool].self, from: data)
        }
        """
    }
}
