//
//  Execute.swift
//  
//
//  Created by Fumito Ito on 2024/05/17.
//

import Foundation
import Mustache
import CommonModules

struct Execute {
    let functions: [Function]

    init(from decls: [FunctionDeclaration]) {
        self.functions = decls.map { Function(from: $0) }
    }

    init(functions: [Function]) {
        self.functions = functions
    }
}

extension Execute: MustacheBoxable {
    var mustacheBox: MustacheBox {
        return Box(["functions": functions])
    }
}
