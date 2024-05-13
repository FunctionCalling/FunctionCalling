//
//  FunctionCallingError.swift
//
//
//  Created by 伊藤史 on 2024/04/30.
//

import Foundation

public enum FunctionCallingError: Error {
    case unknownFunctionCalled
    case failedToGetServiceFromMacroArgument
    case failedToGetTypeNameFromSyntax
    case failedToGetDataFromEncodedTools
    case typeNotSupportedJSONSchema
    case unsupportedReturnType
}

extension FunctionCallingError {
    var localizedDescription: String {
        switch self {
        case .unknownFunctionCalled:
            return "An unknown function is called in the `execute` function."
        case .failedToGetServiceFromMacroArgument:
            return "An unknown service name was passed for the argument of macro."
        case .failedToGetTypeNameFromSyntax:
            return "Can not get the name of function argument type from syntax."
        case .failedToGetDataFromEncodedTools:
            return "Can not get `Data` from encoded `[Tool]` object."
        case .typeNotSupportedJSONSchema:
            return "Can not convert function arguments to types supported by JSONSchema."
        case .unsupportedReturnType:
            return "Return type supports only swift basic types."
        }
    }
}
