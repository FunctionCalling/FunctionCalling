//
//  FunctionTools.swift
//
//
//  Created by Fumito Ito on 2024/08/07.
//

import Foundation
import CommonModules

extension FunctionTool {
    /// Initializes an `FunctionTool` instance from a `FunctionDeclaration` and  a`FunctionCallingService`.
    /// - Parameters:
    ///   - decl: The `FunctionDeclaration` to initialize from.
    ///   - service: The `FunctionCallingService` to use.
    init(from decl: FunctionDeclaration, service: FunctionCallingService) throws {
        self.init(
            service: service,
            function: try .init(from: decl, service: service)
        )
    }
}
