//
//  FunctionParameterDeclaration.swift
//
//
//  Created by 伊藤史 on 2024/05/22.
//

import Foundation
import SwiftSyntax
import CommonModules

public extension FunctionParameterDeclaration {
    /// Initializes a `FunctionParameterDeclaration` instance from a `FunctionParameterSyntax` instance.
    /// - Parameters:
    ///   - decl: The `FunctionParameterSyntax` instance to initialize from.
    ///   - description: An optional description for the function parameter.
    /// - Throws: An error if the type name cannot be retrieved from the syntax.
    init(from decl: FunctionParameterSyntax, description: String? = nil) throws {
        self.init(
            name: decl.name,
            omittingName: decl.omittingName,
            description: description,
            type: .init(name: try decl.typeName, isOptional: decl.isOptional, isArray: decl.isArray)
        )
    }
}
