//
//  DataType.swift
//  
//
//  Created by Fumito Ito on 2024/07/31.
//

import Foundation
import CommonModules

extension InputSchema.DataType {
    init(fromJSONSchemaType: FunctionParameterTypeDeclaration.JSONSchemaType) {
        switch fromJSONSchemaType {
        case .string:
            self = .string
        case .number:
            self = .number
        case .integer:
            self = .integer
        case .object:
            self = .object
        case .array:
            self = .array
        case .boolean:
            self = .boolean
        }
    }
}

extension FunctionParameterTypeDeclaration {
    var jsonSchemaType: JSONSchemaType {
        get throws {
            guard let jsonSchemaType = JSONSchemaType(fromSwiftTypeString: name) else {
                throw FunctionCallingError.typeNotSupportedJSONSchema
            }

            return jsonSchemaType
        }
    }

    /// Representing the types supported by JSONSchema.
    ///
    /// - https://json-schema.org/understanding-json-schema/reference/type
    /// - https://developer.apple.com/documentation/swift/swift-standard-library#values-and-collections
    enum JSONSchemaType: String, RawRepresentable {
        case string
        case number
        case integer
        @available(*, deprecated, message: "`object` type was not supported in this library.")
        case object
        // swiftlint:disable:next line_length
        @available(*, deprecated, message: "`array` type was supported but handled by `isArray` property of `FunctionParameterTypeDeclaration`. Do not use this case directly.")
        case array
        case boolean

        init?(fromSwiftTypeString typeLiteral: String) {
            let unwrappedTypeLiteral = typeLiteral.replacingOccurrences(of: "?", with: "")
            switch unwrappedTypeLiteral {
            case "String", "Character":
                self = .string
            case "Int", "Int8", "Int16", "Int32", "Int64", "UInt", "UInt8", "UInt16", "UInt32", "UInt64":
                self = .integer
            case "Double", "Float":
                self = .number
            case "Bool":
                self = .boolean
            default:
                return nil
            }
        }
    }
}
