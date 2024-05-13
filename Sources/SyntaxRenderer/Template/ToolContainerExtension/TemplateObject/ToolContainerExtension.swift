//
//  File.swift
//  
//
//  Created by Fumito Ito on 2024/05/23.
//

import Foundation
import SwiftSyntax
import CommonModules

public struct ToolContainerExtension {
    public let type: String
    public let executeSyntax: String
    public let allToolsSyntax: String

    init(type: String, executeSyntax: String, allToolsSyntax: String) {
        self.type = type
        self.executeSyntax = executeSyntax
        self.allToolsSyntax = allToolsSyntax
    }

    public init(
        from type: some TypeSyntaxProtocol,
        with functions: [FunctionDeclaration],
        service: FunctionCallingService
    ) throws {
        self.type = type.trimmed.description
        self.executeSyntax = try Self.getExecuteSyntax(from: functions)
        self.allToolsSyntax = try Self.getAllToolsSyntax(from: functions, service: service)
    }

    private static func getExecuteSyntax(from functions: [FunctionDeclaration]) throws -> String {
        let templateObject = Execute(from: functions)

        return try ExecuteSyntax.render(with: templateObject)
    }

    private static func getAllToolsSyntax(
        from functions: [FunctionDeclaration],
        service: FunctionCallingService
    ) throws -> String {
        let templateObject = try functions.map { try Tool(from: $0) }
        let templateType = AllToolsTemplate(service: service)

        return try AllToolsSyntax.render(with: templateObject, templateType: templateType)
    }
}
