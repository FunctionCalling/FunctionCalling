//
//  FunctionCallingPlugin.swift
//
//
//  Created by 伊藤史 on 2024/04/12.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct FunctionCallingPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        FunctionCallingMacro.self,
        CallableFunctionMacro.self
    ]
}
