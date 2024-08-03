//
//  DataType.swift
//  
//
//  Created by Fumito Ito on 2024/07/31.
//

import Foundation
import CommonModules

extension InputSchema.DataType {
    /// Initializes an `InputSchema.DataType` instance from a `JSONSchemaType`.
    /// - Parameter fromJSONSchemaType: The `JSONSchemaType` to initialize from.
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
    /// A computed property that returns the JSON Schema type for the function parameter.
    /// - Throws: `FunctionCallingError.typeNotSupportedJSONSchema` if the type is not supported by JSON Schema.
    var jsonSchemaType: JSONSchemaType {
        get throws {
            guard let jsonSchemaType = JSONSchemaType(fromSwiftTypeString: name) else {
                throw FunctionCallingError.typeNotSupportedJSONSchema
            }

            return jsonSchemaType
        }
    }

    /// An enumeration representing the types supported by JSON Schema.
    ///
    /// - SeeAlso:
    ///   - https://json-schema.org/understanding-json-schema/reference/type
    ///   - https://developer.apple.com/documentation/swift/swift-standard-library#values-and-collections
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

        /// Initializes a `JSONSchemaType` from a Swift type string.
        /// - Parameter typeLiteral: The Swift type string to initialize from.
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
