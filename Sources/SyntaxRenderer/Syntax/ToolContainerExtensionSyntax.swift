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

public enum ToolContainerExtensionSyntax {
    public static func render(from object: ToolContainerExtension) throws -> ExtensionDeclSyntax {
        try ExtensionDeclSyntax("""
        extension \(raw: object.type): ToolContainer {
            \(raw: object.executeSyntax)

            \(raw: object.allToolsSyntax)
        }
        """)
    }
}
