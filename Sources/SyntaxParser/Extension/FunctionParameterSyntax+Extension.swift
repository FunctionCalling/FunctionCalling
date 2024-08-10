//
//  FunctionParameterSyntax+Extension.swift
//  
//
//  Created by Fumito Ito on 2024/05/31.
//

import Foundation
import SwiftSyntax
import CommonModules

extension FunctionParameterSyntax {
    /// A computed property that returns the parameter's name.
    var name: String {
        firstName.text
    }

    /// A computed property that returns the parameter's second name (omitting name), if it exists.
    var omittingName: String? {
        secondName?.text
    }

    /// A computed property that returns the parameter's type name as a string.
    /// - Throws: `FunctionCallingError.failedToGetTypeNameFromSyntax`
    /// if the type name cannot be determined from the syntax.
    var typeName: String {
        get throws {
            if let identifierTypeSyntax = type.as(IdentifierTypeSyntax.self) {
                return identifierTypeSyntax.name.text
            }

            if let optionalTypeSyntax = type.as(OptionalTypeSyntax.self)?.elementType {
                return optionalTypeSyntax.name.text
            }

            if let arrayTypeSyntax = type.as(ArrayTypeSyntax.self)?.elementType {
                return arrayTypeSyntax.name.text
            }

            throw FunctionCallingError.failedToGetTypeNameFromSyntax
        }
    }

    /// A computed property that indicates whether the parameter is optional.
    var isOptional: Bool {
        type.is(OptionalTypeSyntax.self)
    }

    /// A computed property that indicates whether the parameter is an array.
    var isArray: Bool {
        type.is(ArrayTypeSyntax.self) || type.as(OptionalTypeSyntax.self)?.isArray == true
    }
}

extension OptionalTypeSyntax {
    /// A computed property that returns the identifier type of the element, if it exists.
    var elementType: IdentifierTypeSyntax? {
        if let wrappedElementType = wrappedType.as(IdentifierTypeSyntax.self) {
            return wrappedElementType
        } else {
            return wrappedType.as(ArrayTypeSyntax.self)?.elementType
        }
    }

    /// A computed property that indicates whether the optional type is an array.
    var isArray: Bool {
        return wrappedType.is(ArrayTypeSyntax.self)
    }
}

extension ArrayTypeSyntax {
    /// A computed property that returns the identifier type of the array's element, if it exists.
    var elementType: IdentifierTypeSyntax? {
        element.as(IdentifierTypeSyntax.self)
    }
}
