//
//  DeclGroupSyntax+Extension.swift
//  
//
//  Created by Fumito Ito on 2024/05/31.
//

import Foundation
import SwiftSyntax

public extension DeclGroupSyntax {
    /// A computed property that returns an array of `FunctionDeclSyntax` for all function declarations within the declaration group.
    var functions: [FunctionDeclSyntax] {
        memberBlock.members.compactMap { $0.decl.as(FunctionDeclSyntax.self) }
    }
}
