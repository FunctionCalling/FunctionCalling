//
//  Execute.swift
//  
//
//  Created by Fumito Ito on 2024/05/17.
//

import Foundation
import Mustache
import CommonModules

/// A structure representing the execution context for functions.
struct Execute {
    /// An array of `Function` objects to be executed.
    let functions: [Function]

    /// Initializes an `Execute` instance from an array of `FunctionDeclaration` objects.
    /// - Parameter decls: The array of `FunctionDeclaration` objects.
    init(from decls: [FunctionDeclaration]) {
        self.functions = decls.map { Function(from: $0) }
    }

    /// Initializes an `Execute` instance from an array of `Function` objects.
    /// - Parameter functions: The array of `Function` objects.
    init(functions: [Function]) {
        self.functions = functions
    }
}

extension Execute: MustacheBoxable {
    var mustacheBox: MustacheBox {
        return Box(["functions": functions])
    }
}
