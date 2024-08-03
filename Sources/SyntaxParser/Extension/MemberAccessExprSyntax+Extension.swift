//
//  MemberAccessExprSyntax+Extension.swift
//
//
//  Created by Fumito Ito on 2024/05/31.
//

import Foundation
import SwiftSyntax

extension MemberAccessExprSyntax {
    /// A computed property that returns the case name as a string.
    var caseName: String {
        declName.baseName.text
    }
}
