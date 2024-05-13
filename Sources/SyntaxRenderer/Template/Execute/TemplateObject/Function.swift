//
//  Function.swift
//  
//
//  Created by Fumito Ito on 2024/05/17.
//

import Foundation
import Mustache
import CommonModules

struct Function {
    let name: String
    let parameters: [Parameter]
    let isStatic: Bool

    init(from decl: FunctionDeclaration) {
        self.name = decl.name
        self.parameters = decl.parameters
            .enumerated()
            .map {
                Parameter(from: $1, isLast: $0 == decl.parameters.count - 1)
            }
        self.isStatic = decl.isStatic
    }

    init(methodName: String, parameters: [Parameter], isStatic: Bool) {
        self.name = methodName
        self.parameters = parameters
        self.isStatic = isStatic
    }
}

extension Function: MustacheBoxable {
    var mustacheBox: MustacheBox {
        Box([
            "method_name": name,
            "parameters": parameters,
            "is_static": isStatic
        ])
    }
}
