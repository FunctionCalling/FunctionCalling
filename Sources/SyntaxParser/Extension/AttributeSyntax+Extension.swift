//
//  AttributeSyntax+Extension.swift
//  
//
//  Created by Fumito Ito on 2024/07/31.
//

import Foundation
import SwiftSyntax
import CommonModules

public extension AttributeSyntax {
    var service: FunctionCallingService? {
        guard
            let serviceName = arguments?.firstArgumentCaseName,
            let service = FunctionCallingService(rawValue: serviceName) else {
            return nil
        }

        return service
    }
}

extension AttributeSyntax.Arguments {
    var firstArgumentCaseName: String? {
        switch self {
        case .argumentList(let list):
            return list.argumentCaseNames.first
        default:
            return nil
        }
    }
}
