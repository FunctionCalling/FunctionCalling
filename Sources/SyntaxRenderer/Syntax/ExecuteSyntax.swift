//
//  ExecuteSyntax.swift
//
//
//  Created by 伊藤史 on 2024/04/30.
//

import Foundation
import Mustache

enum ExecuteSyntax {
    static func render(with templateObject: Execute) throws -> String {
        let template = try Template(string: ExecuteTemplate.templateString)
        return try template.render(templateObject).emptyLineRemoved
    }
}
