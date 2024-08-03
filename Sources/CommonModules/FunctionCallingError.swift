//
//  FunctionCallingError.swift
//
//
//  Created by 伊藤史 on 2024/04/30.
//

import Foundation

/// An enumeration representing various errors that can occur during function calling.
public enum FunctionCallingError: Error {
    /// The function called is unknown.
    case unknownFunctionCalled
    /// Failed to get the service from the macro argument.
    case failedToGetServiceFromMacroArgument
    /// Failed to get the type name from the syntax.
    case failedToGetTypeNameFromSyntax
    /// Failed to get data from the encoded tools.
    case failedToGetDataFromEncodedTools
    /// The type is not supported by JSON Schema.
    case typeNotSupportedJSONSchema
    /// The return type is unsupported.
    case unsupportedReturnType
}

extension FunctionCallingError {
    /// Provides a localized description of the error.
    var localizedDescription: String {
        switch self {
        case .unknownFunctionCalled:
            return "An unknown function is called in the `execute` function."
        case .failedToGetServiceFromMacroArgument:
            return "An unknown service name was passed for the argument of macro."
        case .failedToGetTypeNameFromSyntax:
            return "Cannot get the name of function argument type from syntax."
        case .failedToGetDataFromEncodedTools:
            return "Cannot get `Data` from encoded `[Tool]` object."
        case .typeNotSupportedJSONSchema:
            return "Cannot convert function arguments to types supported by JSON Schema."
        case .unsupportedReturnType:
            return "Return type supports only Swift basic types."
        }
    }
}
