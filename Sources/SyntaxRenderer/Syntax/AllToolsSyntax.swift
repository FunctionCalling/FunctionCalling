//
//  AllToolsSyntax.swift
//  
//
//  Created by 伊藤史 on 2024/05/24.
//

import Foundation
import Mustache
import CommonModules

enum AllToolsSyntax {
    static func render(
        with templateObject: [Tool],
        templateType: AllToolsTemplate = .claude
    ) throws -> String {
        return try templateType.render(with: templateObject)
    }
}
