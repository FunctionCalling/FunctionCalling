//
//  Tool.swift
//  
//
//  Created by Fumito Ito on 2024/07/31.
//

import Foundation
import CommonModules

extension Tool {
    /// Initializes a `Tool` instance from a `FunctionDeclaration`.
    /// - Parameter decl: The `FunctionDeclaration` to initialize from.
    /// - Parameter service: The `FunctionCallingService` to use.
    /// - Throws: An error if the initialization fails.
    init(from decl: FunctionDeclaration, service: FunctionCallingService) throws {
        self.init(
            service: service,
            name: decl.name,
            description: decl.description,
            inputSchema: try InputSchema(from: decl)
        )
    }
}
