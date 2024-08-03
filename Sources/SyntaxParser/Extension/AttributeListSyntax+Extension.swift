//
//  AttributeListSyntax+Extension.swift
//
//
//  Created by Fumito Ito on 2024/05/31.
//

import Foundation
import SwiftSyntax

extension AttributeListSyntax.Element {
    /// Whether this function is annotated with @Callable.
    var isCallable: Bool {
        switch self {
        case .attribute(let attribute):
            return attribute.attributeName.description == "CallableFunction"
        default:
            return false
        }
    }
}
