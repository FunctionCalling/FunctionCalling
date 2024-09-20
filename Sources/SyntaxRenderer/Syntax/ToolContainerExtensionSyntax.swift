//
//  ToolContainerExtensionSyntax.swift
//
//
//  Created by 伊藤史 on 2024/05/24.
//

import Foundation
import Mustache
import SwiftSyntax
import SwiftSyntaxMacroExpansion

/// An enumeration for rendering the syntax of a tool container extension.
public enum ToolContainerExtensionSyntax {
    /// Renders an `ExtensionDeclSyntax` from a `ToolContainerExtension` object.
    /// - Parameter object: The `ToolContainerExtension` object to be rendered.
    /// - Throws: An error if the rendering fails.
    /// - Returns: An `ExtensionDeclSyntax` representing the rendered extension declaration.
    public static func render(from object: ToolContainerExtension) throws -> ExtensionDeclSyntax {
        try ExtensionDeclSyntax("""
        extension \(raw: object.type): ToolContainer {
            \(raw: object.serviceSytnax)

            \(raw: object.allToolsJSONStringSyntax)

            \(raw: object.allToolsSyntax)
        
            \(raw: object.executeSyntax)
        }
        """)
    }
}
