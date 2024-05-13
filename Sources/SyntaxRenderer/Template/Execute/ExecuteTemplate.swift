//
//  ExecuteTemplate.mustache.swift
//  
//
//  Created by 伊藤史 on 2024/04/30.
//

import Foundation

enum ExecuteTemplate {
    static var templateString: String {
"""
func execute(methodName: String, parameters: [String: Any]) async -> String {
    do {
        switch methodName {
{{#functions}}
        case "{{method_name}}":
{{#parameters}}
{{#required}}
            let {{name}} = parameters["{{name}}"] as! {{type}}{{! Strongly typed cast }}
{{/required}}
{{^required}}
            let {{name}} = parameters["{{name}}"] as? {{type}}{{! Optional cast without default }}
{{/required}}
{{/parameters}}
{{#is_static}}
            return try await Self.{{method_name}}(
{{/is_static}}
{{^is_static}}
            return try await {{method_name}}(
{{/is_static}}
{{#parameters}}
{{#isOmitting}}
                {{name}}{{^isLast}},{{/isLast}}
{{/isOmitting}}
{{^isOmitting}}
                {{name}}: {{name}}{{^isLast}},{{/isLast}}
{{/isOmitting}}
{{/parameters}}
            ).description
{{/functions}}
        default:
            throw FunctionCallingError.unknownFunctionCalled{{! Unknown function error }}
        }
    } catch let error {
        return error.localizedDescription
    }
}
"""
    }
}
