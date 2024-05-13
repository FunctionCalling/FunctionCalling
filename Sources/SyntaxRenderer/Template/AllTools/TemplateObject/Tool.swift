//
//  Tool.swift
//  
//
//  Created by Fumito Ito on 2024/07/31.
//

import Foundation
import CommonModules

extension Tool {
    init(from decl: FunctionDeclaration) throws {
        self.init(
            name: decl.name,
            description: decl.description,
            inputSchema: try InputSchema(from: decl)
        )
    }
}
