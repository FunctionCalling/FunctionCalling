//
//  FunctionParameterTypeDeclaration.swift
//
//
//  Created by 伊藤史 on 2024/05/22.
//

import Foundation

/// The structure that represents the types of function arguments
public struct FunctionParameterTypeDeclaration {
    /// Name of this type
    public let name: String
    /// Whether this type is optional or not
    public let isOptional: Bool
    /// Whether this type is an array type or not
    public let isArray: Bool

    /// Default constructor
    ///
    /// - Parameters:
    ///   - name: Name of this type
    ///   - isOptional: Whether this type is optional or not
    ///   - isArray: Whether this type is an array type or not
    public init(name: String, isOptional: Bool, isArray: Bool) {
        self.name = name
        self.isOptional = isOptional
        self.isArray = isArray
    }
}
