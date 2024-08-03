//
//  ToolContainer.swift
//
//
//  Created by 伊藤史 on 2024/04/28.
//

import Foundation

/// A protocol defining a container for tools that can execute methods and provide a list of all tools.
public protocol ToolContainer {
    /// Executes a method with the given name and parameters.
    /// - Parameters:
    ///   - name: The name of the method to execute.
    ///   - parameters: A dictionary of parameters to pass to the method.
    /// - Returns: A `String` representing the result of the method execution.
    func execute(methodName name: String, parameters: [String: Any]) async -> String

    /// A `String` representing all tools in the container.
    var allTools: String { get }
}

extension ToolContainer {
    /// The name of the protocol as a `String`.
    static var protocolName: String {
        String(describing: Self.self)
    }
}
