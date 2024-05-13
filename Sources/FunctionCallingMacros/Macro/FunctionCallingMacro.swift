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

    static private func renderExtensionSyntax(
        from type: some TypeSyntaxProtocol,
        with declarations: [FunctionDeclaration],
        service: FunctionCallingService
    ) throws -> ExtensionDeclSyntax {
        let templateObject = try ToolContainerExtension(from: type, with: declarations, service: service)
        return try ToolContainerExtensionSyntax.render(from: templateObject)
    }
}
