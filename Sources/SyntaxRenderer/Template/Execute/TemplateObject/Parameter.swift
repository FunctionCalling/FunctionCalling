//
//  Parameter.swift
//  
//
//  Created by Fumito Ito on 2024/05/17.
//

import Foundation
import Mustache
import CommonModules

/// A structure representing a parameter with a name, type, and other attributes.
struct Parameter {
    /// The name of the parameter.
    let name: String
    /// The omitting name of the parameter, if any.
    let omittingName: String?
    /// Indicates whether the parameter is required.
    let required: Bool
    /// The type of the parameter.
    let type: String
    /// Indicates whether the parameter is the last one in the list.
    let isLast: Bool

    /// A computed property that indicates whether the parameter's name is omitted.
    var isOmitting: Bool {
        name == "_"
    }

    /// Initializes a `Parameter` instance with the given attributes.
    /// - Parameters:
    ///   - name: The name of the parameter.
    ///   - omittingName: The omitting name of the parameter, if any.
    ///   - required: A boolean indicating whether the parameter is required.
    ///   - type: The type of the parameter.
    ///   - isLast: A boolean indicating whether the parameter is the last one in the list.
    init(name: String, omittingName: String?, required: Bool, type: String, isLast: Bool) {
        self.name = name
        self.omittingName = omittingName
        self.required = required
        self.type = type
        self.isLast = isLast
    }

    /// Initializes a `Parameter` instance from a `FunctionParameterDeclaration`.
    /// - Parameters:
    ///   - decl: The `FunctionParameterDeclaration` to initialize from.
    ///   - isLast: A boolean indicating whether the parameter is the last one in the list.
    init(from decl: FunctionParameterDeclaration, isLast: Bool) {
        self.name = decl.name
        self.omittingName = decl.omittingName
        self.required = decl.type.isOptional == false
        self.type = decl.type.representationWithOptionality
        self.isLast = isLast
    }
}

extension Parameter: MustacheBoxable {
    var mustacheBox: MustacheBox {
        Box([
            "name": omittingName ?? name,
            "required": required,
            "type": type,
            "isLast": isLast,
            "isOmitting": isOmitting
        ])
    }
}

fileprivate extension FunctionParameterTypeDeclaration {
    /// A computed property that returns the type's representation as a string, including optionality.
    var representationWithOptionality: String {
        var typeName: String

        if isArray {
            typeName = "[\(name)]"
        } else {
            typeName = name
        }

        if isOptional {
            return "\(typeName)?"
        } else {
            return typeName
        }
    }
}
