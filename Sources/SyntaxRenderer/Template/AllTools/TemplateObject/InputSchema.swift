//
//  InputSchema.swift
//  
//
//  Created by Fumito Ito on 2024/07/31.
//

import Foundation
import CommonModules

extension InputSchema {
    convenience init(from decl: FunctionDeclaration) throws {
        self.init(
            type: .object,
            format: nil,
            description: decl.description,
            nullable: nil,
            enumValues: nil,
            items: nil,
            properties: try decl.parameters.reduce(into: [String: InputSchema](), { partialResult, parameter in
                partialResult[parameter.name] = try InputSchema(fromParameterDecl: parameter)
            }),
            requiredProperties: nil
        )
    }

    convenience init(fromParameterDecl decl: FunctionParameterDeclaration) throws {
        self.init(
            type: decl.type.isArray ? .array : .init(fromJSONSchemaType: try decl.type.jsonSchemaType),
            format: nil,
            description: decl.description,
            nullable: decl.type.isOptional,
            enumValues: nil,
            items: decl.type.isArray ? InputSchema(
                type: .init(fromJSONSchemaType: try decl.type.jsonSchemaType),
                format: nil,
                description: nil,
                nullable: nil,
                enumValues: nil,
                items: nil,
                properties: nil,
                requiredProperties: nil
            ) : nil,
            properties: nil,
            requiredProperties: nil
        )
    }
}
