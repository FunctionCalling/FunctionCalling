//
//  ToolTests.swift
//  
//
//  Created by 伊藤史 on 2024/08/08.
//

import XCTest
import CommonModules
@testable import SyntaxRenderer

final class ToolTests: XCTestCase {
    static func getHTML(service: FunctionCallingService = .claude) -> Tool {
        .init(
            service: service,
            name: "getHTML",
            description: "This is description for `getHTML` method.",
            inputSchema: .init(
                type: .object,
                properties: [
                    "urlString": .init(
                        type: .string,
                        description: "This is description for `urlString` property",
                        nullable: false
                    )
                ],
                requiredProperties: [
                    "urlString"
                ]
            )
        )
    }

    static func timeOfDay(service: FunctionCallingService = .claude) -> Tool {
        .init(
            service: service,
            name: "timeOfDay",
            description: "This is description for `timeOfDay` method.",
            inputSchema: .init(
                type: .object,
                properties: [
                    "timeZone": .init(
                        type: .string,
                        description: "This is description for `timeOfDay` property",
                        nullable: false
                    ),
                    "DST": .init(
                        type: .string,
                        description: "This is description for `DST` property",
                        nullable: true
                    )
                ],
                requiredProperties: [
                    "timeZone"
                ]
            )
        )
    }

    func testEncodeForClaude() throws {
        let tool = Self.getHTML()
        let jsonData = try FunctionCallingEncoder.encode(tool)
        if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            // swiftlint:disable:next force_cast
            XCTAssertEqual(dictionary["name"] as! String, "getHTML")
            // swiftlint:disable:next force_cast
            XCTAssertEqual(dictionary["description"] as! String, "This is description for `getHTML` method.")

            let inputSchema = try XCTUnwrap(dictionary["input_schema"] as? [String: Any])
            // swiftlint:disable:next force_cast
            XCTAssertEqual(inputSchema["type"] as! String, "object")

            let properties = try XCTUnwrap(inputSchema["properties"] as? [String: Any])
            XCTAssertEqual(properties.keys.count, 1)
            XCTAssertEqual(properties.keys.first, "urlString")

            let requiredProperties = try XCTUnwrap(inputSchema["required"] as? [String])
            XCTAssertEqual(requiredProperties.count, 1)
            XCTAssertEqual(requiredProperties.first, "urlString")
        } else {
            XCTFail("JSON data should be selialized into dictionary")
        }
    }

    func testDecodeForClaude() throws {
        let tool = Self.getHTML()
        let jsonData = try FunctionCallingEncoder.encode(tool)
        let result = try FunctionCallingDecoder.decode(Tool.self, from: jsonData)

        XCTAssertEqual(result.name, "getHTML")
        XCTAssertEqual(result.service, .claude)
        XCTAssertEqual(result.description, "This is description for `getHTML` method.")
        XCTAssertEqual(result.inputSchema.type, .object)
        XCTAssertEqual(result.inputSchema.properties?.count, 1)
        let urlString = try XCTUnwrap(result.inputSchema.properties?["urlString"])
        XCTAssertEqual(urlString.type, .string)
        XCTAssertEqual(urlString.description, "This is description for `urlString` property")
        XCTAssertEqual(urlString.nullable, false)
        XCTAssertEqual(result.inputSchema.requiredProperties, ["urlString"])
    }

    func testEncodeForChatGPT() throws {
        let tool = Self.getHTML(service: .chatGPT)
        let jsonData = try FunctionCallingEncoder.encode(tool)
        if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            // swiftlint:disable:next force_cast
            XCTAssertEqual(dictionary["name"] as! String, "getHTML")
            // swiftlint:disable:next force_cast
            XCTAssertEqual(dictionary["description"] as! String, "This is description for `getHTML` method.")

            let parameters = try XCTUnwrap(dictionary["parameters"] as? [String: Any])
            // swiftlint:disable:next force_cast
            XCTAssertEqual(parameters["type"] as! String, "object")

            let properties = try XCTUnwrap(parameters["properties"] as? [String: Any])
            XCTAssertEqual(properties.keys.count, 1)
            XCTAssertEqual(properties.keys.first, "urlString")

            let requiredProperties = try XCTUnwrap(parameters["required"] as? [String])
            XCTAssertEqual(requiredProperties.count, 1)
            XCTAssertEqual(requiredProperties.first, "urlString")
        } else {
            XCTFail("JSON data should be selialized into dictionary")
        }
    }

    func testDecodeForChatGPT() throws {
        let tool = Self.getHTML(service: .chatGPT)
        let jsonData = try FunctionCallingEncoder.encode(tool)
        let result = try FunctionCallingDecoder.decode(Tool.self, from: jsonData)

        XCTAssertEqual(result.name, "getHTML")
        XCTAssertEqual(result.service, .chatGPT)
        XCTAssertEqual(result.description, "This is description for `getHTML` method.")
        XCTAssertEqual(result.inputSchema.type, .object)
        XCTAssertEqual(result.inputSchema.properties?.count, 1)
        let urlString = try XCTUnwrap(result.inputSchema.properties?["urlString"])
        XCTAssertEqual(urlString.type, .string)
        XCTAssertEqual(urlString.description, "This is description for `urlString` property")
        XCTAssertEqual(urlString.nullable, false)
        XCTAssertEqual(result.inputSchema.requiredProperties, ["urlString"])
    }

    func testEncodeForLlamaOrGemini() throws {
        let tool = Self.getHTML(service: .llamaOrGemini)
        let jsonData = try FunctionCallingEncoder.encode(tool)
        if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            // swiftlint:disable:next force_cast
            XCTAssertEqual(dictionary["name"] as! String, "getHTML")
            // swiftlint:disable:next force_cast
            XCTAssertEqual(dictionary["description"] as! String, "This is description for `getHTML` method.")

            let parameters = try XCTUnwrap(dictionary["parameters"] as? [String: Any])
            // swiftlint:disable:next force_cast
            XCTAssertEqual(parameters["type"] as! String, "object")

            let properties = try XCTUnwrap(parameters["properties"] as? [String: Any])
            XCTAssertEqual(properties.keys.count, 1)
            XCTAssertEqual(properties.keys.first, "urlString")

            let requiredProperties = try XCTUnwrap(parameters["required"] as? [String])
            XCTAssertEqual(requiredProperties.count, 1)
            XCTAssertEqual(requiredProperties.first, "urlString")
        } else {
            XCTFail("JSON data should be selialized into dictionary")
        }
    }

    func testDecodeForLlamaOrGemini() throws {
        let tool = Self.getHTML(service: .llamaOrGemini)
        let jsonData = try FunctionCallingEncoder.encode(tool)
        let result = try FunctionCallingDecoder.decode(Tool.self, from: jsonData)

        XCTAssertEqual(result.name, "getHTML")
        XCTAssertEqual(result.service, .llamaOrGemini)
        XCTAssertEqual(result.description, "This is description for `getHTML` method.")
        XCTAssertEqual(result.inputSchema.type, .object)
        XCTAssertEqual(result.inputSchema.properties?.count, 1)
        let urlString = try XCTUnwrap(result.inputSchema.properties?["urlString"])
        XCTAssertEqual(urlString.type, .string)
        XCTAssertEqual(urlString.description, "This is description for `urlString` property")
        XCTAssertEqual(urlString.nullable, false)
        XCTAssertEqual(result.inputSchema.requiredProperties, ["urlString"])
    }
}
