//
//  Function.swift
//  
//
//  Created by Fumito Ito on 2024/05/17.
//

import Foundation
import Mustache
import CommonModules

/// A structure representing a function with a name, parameters, and static status.
struct Function {
    /// The name of the function.
    let name: String
    /// The parameters of the function.
    let parameters: [Parameter]
    /// Indicates whether the function is static.
    let isStatic: Bool

    /// Initializes a `Function` instance from a `FunctionDeclaration`.
    /// - Parameter decl: The `FunctionDeclaration` to initialize from.
    init(from decl: FunctionDeclaration) {
        self.name = decl.name
        self.parameters = decl.parameters
            .enumerated()
            .map {
                Parameter(from: $1, isLast: $0 == decl.parameters.count - 1)
            }
        self.isStatic = decl.isStatic
    }

    /// Initializes a `Function` instance with the given method name, parameters, and static status.
    /// - Parameters:
    ///   - methodName: The name of the method.
    ///   - parameters: An array of `Parameter` objects.
    ///   - isStatic: A boolean indicating whether the method is static.
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
