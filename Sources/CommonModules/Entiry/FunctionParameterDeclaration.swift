//
//  FunctionParameterDeclaration.swift
//  
//
//  Created by Fumito Ito on 2024/07/31.
//

import Foundation

/// The structure that represents the arguments of a function
public struct FunctionParameterDeclaration {
    /// Name of this argument
    public let name: String
    /// Whether this argument has an ommiting name or not
    public let omittingName: String?
    /// Description of this argument
    public let description: String?
    /// Type of this argument
    public let type: FunctionParameterTypeDeclaration

    /// Default constructor
    ///
    /// - Parameters:
    ///   - name: Name of this argument
    ///   - omittingName: Whether this argument has an ommiting name or not
    ///   - description: Description of this argument
    ///   - type: Type of this argument
    public init(name: String, omittingName: String?, description: String?, type: FunctionParameterTypeDeclaration) {
        self.name = name
        self.omittingName = omittingName
        self.description = description
        self.type = type
    }
}
