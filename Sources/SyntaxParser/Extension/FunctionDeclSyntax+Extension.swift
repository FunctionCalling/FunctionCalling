//
//  FunctionDecl+Extension.swift
//
//
//  Created by Fumito Ito on 2024/05/17.
//

import Foundation
import SwiftSyntax
import DocumetationComment

/// An extension for `FunctionDeclSyntax` to provide additional computed properties for various function attributes and metadata.
extension FunctionDeclSyntax {
    /// A computed property that returns the function's name as text.
    var nameText: String {
        name.text
    }

    /// A computed property that returns an array of the function's parameters.
    var parameters: [FunctionParameterSyntax] {
        signature.parameterClause.parameters.map { $0 }
    }

    /// A computed property that returns the documentation comment for the function, if it exists.
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

    /// A computed property that indicates whether the function is callable, based on its attributes.
    var isCallable: Bool {
        return attributes.contains { $0.isCallable }
    }

    /// A computed property that indicates whether the function is static.
    var isStatic: Bool {
        return modifiers.contains(where: { $0.name.text == "static" })
    }

    /// A computed property that checks if the function has a valid return type.
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
