//
//  FunctionDeclaration.swift
//  
//
//  Created by 伊藤史 on 2024/05/22.
//

import Foundation
import SwiftSyntax
import CommonModules

public extension FunctionDeclaration {
    /// Create a `FunctionDeclaration` from a function with `@CallableFunction`
    ///
    /// It returns `nil` if the constructor argument is a function without `@CallableFunction`.
    ///
    /// - Parameter decl: DeclSyntax with `@CallableFunction`
    init?(from decl: FunctionDeclSyntax) throws {
        guard decl.isCallable else {
            return nil
        }

        guard decl.isValidReturnType else {
            throw FunctionCallingError.unsupportedReturnType
        }

        guard let documentationComment = decl.documentationComment else {
            self.init(
                name: decl.nameText,
                description: "",
                parameters: try decl.parameters.map { try FunctionParameterDeclaration(from: $0) },
                isStatic: decl.isStatic
            )
            return
        }

        self.init(
            name: decl.nameText,
            description: documentationComment.raw,
            parameters: try decl.parameters.map { syntax in
                let description = documentationComment.parameters.first(where: { $0.name == syntax.name })
                return try FunctionParameterDeclaration(from: syntax, description: description?.description)
            },
            isStatic: decl.isStatic
        )
    }
}
