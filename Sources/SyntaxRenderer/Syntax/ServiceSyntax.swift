//
//  ServiceSyntax.swift
//  FunctionCalling
//
//  Created by 伊藤史 on 2024/09/20.
//

import CommonModules

/// An enumeration for rendering services for the container.
enum ServiceSyntax {
    /// Renders the `FunctionCallingService` using the given template type.
    /// - Parameters:
    ///   - service: The `FunctionCallingService` used for the tool container.
    /// - Throws: An error if the rendering fails.
    /// - Returns: A `String` representation of the rendered tools.
    static func render(service: FunctionCallingService) -> String {
        return ServiceTemplate.render(service: service)
    }
}
