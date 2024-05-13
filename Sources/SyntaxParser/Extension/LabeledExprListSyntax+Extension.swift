//
//  LabeledExprListSyntax+Extension.swift
//  
//
//  Created by Fumito Ito on 2024/05/31.
//

import Foundation
import SwiftSyntax

extension LabeledExprListSyntax {
    var argumentCaseNames: [String] {
        map { syntax in
            syntax.expression.as(MemberAccessExprSyntax.self)?.caseName
        }
        .compactMap { $0 }
    }
}
