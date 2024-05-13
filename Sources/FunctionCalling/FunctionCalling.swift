//
//  FunctionCalling.swift
//
//
//  Created by 伊藤史 on 2024/07/29.
//

import CommonModules

@attached(peer)
public macro CallableFunction() = #externalMacro(module: "FunctionCallingMacros", type: "CallableFunctionMacro")

@attached(extension, conformances: ToolContainer, names: named(execute), named(allTools))
// swiftlint:disable:next line_length
public macro FunctionCalling(service: FunctionCallingService) = #externalMacro(module: "FunctionCallingMacros", type: "FunctionCallingMacro")
