//
//  FunctionDecl+Extension.swift
//
//
//  Created by Fumito Ito on 2024/05/17.
//

import Foundation
import SwiftSyntax
import DocumetationComment

extension FunctionDeclSyntax {
    var nameText: String {
        name.text
    }

    var parameters: [FunctionParameterSyntax] {
        signature.parameterClause.parameters.map { $0 }
    }

    var documentationComment: DocumentationComment? {
        if let commentBeforeAttribute = attributes.first?.leadingTrivia, commentBeforeAttribute.containsDocComment {
            // Pattern: Doc comment above attribute
            //
            // '''
            // /// This is some comment
            // @CallableFunction
            // func foo() {...}
            // '''
            return try? DocumentationComment(commentBeforeAttribute.toDocCommentString)
        }

        if let commentBeforeModifier = modifiers.first?.leadingTrivia, commentBeforeModifier.containsDocComment {
            // Pattern: Doc comment between attribute and modifier
            //
            // '''
            // @CallableFunction
            // /// This is some comment
            // static func foo() {...}
            // '''
            return try? DocumentationComment(commentBeforeModifier.toDocCommentString)
        }

        // Pattern: Doc comment under attribute
        //
        // '''
        // @CallableFunction
        // /// This is some comment
        // func foo() {...}
        // '''
        return try? DocumentationComment(funcKeyword.leadingTrivia.toDocCommentString)
    }

    var isCallable: Bool {
        return attributes.contains { $0.isCallable }
    }

    var isStatic: Bool {
        return modifiers.contains(where: { $0.name.text == "static" })
    }

    var isValidReturnType: Bool {
        guard let returnClauseType = signature.returnClause?.type else {
            // Void
            return false
        }

        if returnClauseType.is(OptionalTypeSyntax.self) {
            // does not support optional type
            return false
        }

        if let identifierTypeSyntax = returnClauseType.as(IdentifierTypeSyntax.self) {
            return SupportingReturnType.isValid(identifierTypeSyntax)
        }

        if let arrayTypeSyntax = returnClauseType.as(ArrayTypeSyntax.self)?.elementType {
            return SupportingReturnType.isValid(arrayTypeSyntax)
        }

        // unknown type
        return false
    }

    /// Represents a return type that can be supported by a function with `@CallableFunction`.
    ///
    /// If `isValid` returns false, a compile error occurs. The following types are currently supported.
    /// - String
    /// - Character
    /// - Int
    /// - Int8
    /// - Int16
    /// - Int32
    /// - Int64
    /// - UInt
    /// - UInt8
    /// - UInt16
    /// - UInt32
    /// - UInt64
    /// - Double
    /// - Float
    /// - Bool
    /// - `Date`
    /// - Calendar
    /// - DateComponents
    /// - TimeInterval
    /// - Data
    /// - URL
    /// - URLComponents
    /// - URLRequest
    enum SupportingReturnType {
        // swiftlint:disable:next todo
        // FIXME: I want to be able to determine whether the return type conforms to `CustomStringConvertible`.
        static func isValid(_ identifierTypeSyntax: IdentifierTypeSyntax) -> Bool {
            isValid(from: identifierTypeSyntax.name.text)
        }

        static func isValid(from typeString: String) -> Bool {
            switch typeString {
            case
                "String",
                "Character",
                "Int",
                "Int8",
                "Int16",
                "Int32",
                "Int64",
                "UInt",
                "UInt8",
                "UInt16",
                "UInt32",
                "UInt64",
                "Double",
                "Float",
                "Bool",
                "Date",
                "Calendar",
                "DateComponents",
                "TimeInterval",
                "Data",
                "URL",
                "URLComponents",
                "URLRequest":
                return true
            default:
                return false
            }
        }
    }

}
