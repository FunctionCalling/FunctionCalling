//
//  FunctionDeclaration.swift
//
//
//  Created by Fumito Ito on 2024/07/31.
//

import Foundation

/// The structure that represents the definition of a function
public struct FunctionDeclaration {
    /// Name of function
    public let name: String
    /// Description of function
    public let description: String
    /// Parameters of function
    public let parameters: [FunctionParameterDeclaration]
    /// Whether this function is a static function or not
    public let isStatic: Bool

    /// Default constructor
    ///
    /// - Parameters:
    ///   - name: Name of function
    ///   - description: Description of function
    ///   - parameters: Parameters of function
    ///   - isStatic: Whether this function is a static function or not
    public init(name: String, description: String, parameters: [FunctionParameterDeclaration], isStatic: Bool) {
        self.name = name
        self.description = description
        self.parameters = parameters
        self.isStatic = isStatic
    }
}
