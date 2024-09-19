//
//  ServiceTemplate.swift
//  FunctionCalling
//
//  Created by 伊藤史 on 2024/09/20.
//

import CommonModules

enum ServiceTemplate {
    /// Renders the getter for the service.
    /// - Parameter service: The `FunctionCallingService` used for the tool container
    /// - Returns: A `String` representation of the rendered tools.
    static func render(service: FunctionCallingService) -> String {
        return """
        var service: FunctionCallingService {
            return FunctionCallingService.\(service.rawValue)
        }
        """
    }
}

