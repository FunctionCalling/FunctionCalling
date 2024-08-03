//
//  FunctionCallingMacro.swift
//
//
//  Created by 伊藤史 on 2024/04/28.
//

import CommonModules
import Foundation
import SyntaxParser
import SyntaxRenderer
import SwiftSyntax
import SwiftSyntaxMacros

/// A structure representing a macro that adds function calling capabilities to types.
public struct FunctionCallingMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let service = node.service else {
            throw FunctionCallingError.failedToGetServiceFromMacroArgument
        }

        let declarations = try declaration.functions.compactMap { try FunctionDeclaration(from: $0) }

        return [
            try renderExtensionSyntax(from: type, with: declarations, service: service)
        ]
    }

    /// Renders the extension syntax from the given type, function declarations, and service.
    /// - Parameters:
    ///   - type: The type syntax protocol for which the extension is being rendered.
    ///   - declarations: An array of function declarations.
    ///   - service: The service for function calling.
    /// - Throws: An error if rendering the extension syntax fails.
    /// - Returns: An `ExtensionDeclSyntax` representing the extension.
    static private func renderExtensionSyntax(
        from type: some TypeSyntaxProtocol,
        with declarations: [FunctionDeclaration],
        service: FunctionCallingService
    ) throws -> ExtensionDeclSyntax {
        let templateObject = try ToolContainerExtension(from: type, with: declarations, service: service)
        return try ToolContainerExtensionSyntax.render(from: templateObject)
    }
}
