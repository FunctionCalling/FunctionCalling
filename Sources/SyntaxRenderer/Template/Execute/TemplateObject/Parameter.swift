//
//  Parameter.swift
//  
//
//  Created by Fumito Ito on 2024/05/17.
//

import Foundation
import Mustache
import CommonModules

struct Parameter {
    let name: String
    let omittingName: String?
    let required: Bool
    let type: String
    let isLast: Bool
    var isOmitting: Bool {
        name == "_"
    }

    init(name: String, omittingName: String?, required: Bool, type: String, isLast: Bool) {
        self.name = name
        self.omittingName = omittingName
        self.required = required
        self.type = type
        self.isLast = isLast
    }

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
