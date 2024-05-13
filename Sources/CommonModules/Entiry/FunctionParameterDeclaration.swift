//
//  FunctionParameterDeclaration.swift
//  
//
//  Created by Fumito Ito on 2024/07/31.
//

import Foundation

public struct FunctionParameterDeclaration {
    public let name: String
    public let omittingName: String?
    public let description: String?
    public let type: FunctionParameterTypeDeclaration

    public init(name: String, omittingName: String?, description: String?, type: FunctionParameterTypeDeclaration) {
        self.name = name
        self.omittingName = omittingName
        self.description = description
        self.type = type
    }
}
