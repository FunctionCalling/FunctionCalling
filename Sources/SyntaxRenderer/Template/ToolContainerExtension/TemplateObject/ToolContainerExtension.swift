//
//  ToolContainerExtension.swift
//
//
//  Created by Fumito Ito on 2024/05/23.
//

import Foundation
import SwiftSyntax
import CommonModules

/// A structure representing an extension for a tool container.
public struct ToolContainerExtension {
    /// The type of the tool container.
    public let type: String
    /// The syntax for the execute function.
    public let executeSyntax: String
    /// The syntax for all tools.
    public let allToolsJSONStringSyntax: String
    public let allToolsSyntax: String
    public let serviceSytnax: String

    /// Initializes a `ToolContainerExtension` instance with the given type, execute syntax, and all tools syntax.
    /// - Parameters:
    ///   - type: The type of the tool container.
    ///   - executeSyntax: The syntax for the execute function.
    ///   - allToolsJSONStringSyntax: The syntax for all tools.
    init(
        type: String,
        executeSyntax: String,
        allToolsJSONStringSyntax: String,
        allToolsSyntax: String,
        serviceSyntax: String
    ) {
        self.type = type
        self.executeSyntax = executeSyntax
        self.allToolsJSONStringSyntax = allToolsJSONStringSyntax
        self.allToolsSyntax = allToolsSyntax
        self.serviceSytnax = serviceSyntax
    }

    /// Initializes a `ToolContainerExtension` instance from a type syntax protocol, functions, and service.
    /// - Parameters:
    ///   - type: The type syntax protocol.
    ///   - functions: An array of `FunctionDeclaration` objects.
    ///   - service: The `FunctionCallingService` used for the tool container.
    /// - Throws: An error if the initialization fails.
    public init(
        from type: some TypeSyntaxProtocol,
        with functions: [FunctionDeclaration],
        service: FunctionCallingService
    ) throws {
        self.type = type.trimmed.description
        self.executeSyntax = try Self.getExecuteSyntax(from: functions)
        self.allToolsJSONStringSyntax = try Self.getAllToolsJSONStringSyntax(from: functions, service: service)
        self.allToolsSyntax = Self.getAllToolsSyntax()
        self.serviceSytnax = Self.getServiceSyntax(service: service)
    }

    /// Generates the execute syntax from an array of function declarations.
    /// - Parameter functions: An array of `FunctionDeclaration` objects.
    /// - Throws: An error if the syntax generation fails.
    /// - Returns: A `String` representing the execute syntax.
    private static func getExecuteSyntax(from functions: [FunctionDeclaration]) throws -> String {
        let templateObject = Execute(from: functions)
        return try ExecuteSyntax.render(with: templateObject)
    }

    /// Generates the all tools syntax from an array of function declarations and a service.
    /// - Parameters:
    ///   - functions: An array of `FunctionDeclaration` objects.
    ///   - service: The `FunctionCallingService` used for the tool container.
    /// - Throws: An error if the syntax generation fails.
    /// - Returns: A `String` representing the all tools syntax.
    private static func getAllToolsJSONStringSyntax(
        from functions: [FunctionDeclaration],
        service: FunctionCallingService
    ) throws -> String {
        let templateObject = try functions.map { try FunctionTool(from: $0, service: service) }
        return try AllToolsJSONStringSyntax.render(with: templateObject, service: service)
    }

    private static func getAllToolsSyntax() -> String {
        return AllToolsSyntax.render()
    }

    private static func getServiceSyntax(service: FunctionCallingService) -> String {
        return ServiceSyntax.render(service: service)
    }
}
