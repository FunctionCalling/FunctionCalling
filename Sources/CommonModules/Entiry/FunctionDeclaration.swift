//
//  FunctionDeclaration.swift
//
//
//  Created by Fumito Ito on 2024/07/31.
//

import Foundation

public struct FunctionDeclaration {
    public let name: String
    public let description: String
    public let parameters: [FunctionParameterDeclaration]
    public let isStatic: Bool

    public init(name: String, description: String, parameters: [FunctionParameterDeclaration], isStatic: Bool) {
        self.name = name
        self.description = description
        self.parameters = parameters
        self.isStatic = isStatic
    }
}
