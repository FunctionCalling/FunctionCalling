//
//  AllToolsTemplate.swift
//
//
//  Created by 伊藤史 on 2024/05/20.
//

import Foundation
import CommonModules

enum AllToolsTemplate {
    case claude

    init(service: FunctionCallingService) {
        switch service {
        case .claude:
            self = .claude
        }
    }

    func render(with templateObject: [Tool]) throws -> String {
        switch self {
        case .claude:
            let tools = try FunctionCallingEncoder.encode(templateObject)
            guard let jsonString = String(data: tools, encoding: .utf8) else {
                throw FunctionCallingError.failedToGetDataFromEncodedTools
            }

            return """
            var allTools: String {
                \"""
                \(jsonString.emptyLineRemoved.replacingOccurrences(of: "\n", with: ""))
                \"""
            }
            """
        }
    }
}
