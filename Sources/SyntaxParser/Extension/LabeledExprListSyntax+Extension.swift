//
//  LabeledExprListSyntax+Extension.swift
//  
//
//  Created by Fumito Ito on 2024/05/31.
//

import Foundation
import SwiftSyntax

extension LabeledExprListSyntax {
    /// A computed property that returns an array of case names for the arguments in the list.
    var argumentCaseNames: [String] {
        map { syntax in
            syntax.expression.as(MemberAccessExprSyntax.self)?.caseName
        }
        .compactMap { $0 }
    }
}
