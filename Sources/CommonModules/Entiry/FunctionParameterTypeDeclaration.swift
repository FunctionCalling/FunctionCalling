//
//  FunctionParameterTypeDeclaration.swift
//
//
//  Created by 伊藤史 on 2024/05/22.
//

import Foundation

public struct FunctionParameterTypeDeclaration {
    public let name: String
    public let isOptional: Bool
    public let isArray: Bool

    public init(name: String, isOptional: Bool, isArray: Bool) {
        self.name = name
        self.isOptional = isOptional
        self.isArray = isArray
    }
}
