//
//  ToolContainer.swift
//
//
//  Created by 伊藤史 on 2024/04/28.
//

import Foundation

public protocol ToolContainer {
    func execute(methodName name: String, parameters: [String: Any]) async -> String
    var allTools: String { get }
}

extension ToolContainer {
    static var protocolName: String {
        String(describing: Self.self)
    }
}
