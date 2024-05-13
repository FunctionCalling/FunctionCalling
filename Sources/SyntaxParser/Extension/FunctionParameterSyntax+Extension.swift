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
    var name: String {
        firstName.text
    }

    var omittingName: String? {
        secondName?.text
    }

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

    var isOptional: Bool {
        type.is(OptionalTypeSyntax.self)
    }

    var isArray: Bool {
        type.is(ArrayTypeSyntax.self) || type.as(OptionalTypeSyntax.self)?.isArray == true
    }
}

extension OptionalTypeSyntax {
    var elementType: IdentifierTypeSyntax? {
        if let wrappedElementType = wrappedType.as(IdentifierTypeSyntax.self) {
            return wrappedElementType
        } else {
            return wrappedType.as(ArrayTypeSyntax.self)?.elementType
        }
    }

    var isArray: Bool {
        return wrappedType.is(ArrayTypeSyntax.self)
    }
}

extension ArrayTypeSyntax {
    var elementType: IdentifierTypeSyntax? {
        element.as(IdentifierTypeSyntax.self)
    }
}
