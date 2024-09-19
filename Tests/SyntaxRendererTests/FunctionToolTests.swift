//
//  FunctionToolTests.swift
//
//
//  Created by Fumito Ito on 2024/08/07.
//

import XCTest
import CommonModules
@testable import SyntaxRenderer

final class FunctionToolTests: XCTestCase {
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

    // MARK: Claude

    func testEncodingFunctionForClaude() throws {
        let tool = FunctionTool(service: .claude, function: Self.getHTML())
        let jsonData = try FunctionCallingService.claude.encoder.encode(tool)
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

    func testEncodingFunctionsForClaude() throws {
        let tools = [
            FunctionTool(service: .claude, function: Self.getHTML()),
            FunctionTool(service: .claude, function: Self.timeOfDay())
        ]

        let jsonData = try FunctionCallingService.claude.encoder.encode(tools)
        if let array = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
            XCTAssertEqual(array.count, 2)

            if let getHTML = array.first {
                // swiftlint:disable:next force_cast
                XCTAssertEqual(getHTML["name"] as! String, "getHTML")
                // swiftlint:disable:next force_cast
                XCTAssertEqual(getHTML["description"] as! String, "This is description for `getHTML` method.")

                let inputSchema = try XCTUnwrap(getHTML["input_schema"] as? [String: Any])
                // swiftlint:disable:next force_cast
                XCTAssertEqual(inputSchema["type"] as! String, "object")

                let properties = try XCTUnwrap(inputSchema["properties"] as? [String: Any])
                XCTAssertEqual(properties.keys.count, 1)
                XCTAssertEqual(properties.keys.first, "urlString")

                let requiredProperties = try XCTUnwrap(inputSchema["required"] as? [String])
                XCTAssertEqual(requiredProperties.count, 1)
                XCTAssertEqual(requiredProperties.first, "urlString")
            }

            if let timeOfDay = array.last {
                // swiftlint:disable:next force_cast
                XCTAssertEqual(timeOfDay["name"] as! String, "timeOfDay")
                // swiftlint:disable:next force_cast
                XCTAssertEqual(timeOfDay["description"] as! String, "This is description for `timeOfDay` method.")

                let inputSchema = try XCTUnwrap(timeOfDay["input_schema"] as? [String: Any])
                // swiftlint:disable:next force_cast
                XCTAssertEqual(inputSchema["type"] as! String, "object")

                let properties = try XCTUnwrap(inputSchema["properties"] as? [String: Any])
                XCTAssertEqual(properties.keys.count, 2)
                XCTAssertTrue(properties.keys.contains(where: { $0 == "timeZone"}))
                XCTAssertTrue(properties.keys.contains(where: { $0 == "DST"}))

                let requiredProperties = try XCTUnwrap(inputSchema["required"] as? [String])
                XCTAssertEqual(requiredProperties.count, 1)
                XCTAssertEqual(requiredProperties.first, "timeZone")
            }
        } else {
            XCTFail("JSON data should be selialized into arrat")
        }
    }

    func testDecodingFunctionClaude() throws {
        let tool = FunctionTool(service: .claude, function: Self.getHTML())
        let jsonData = try FunctionCallingService.claude.encoder.encode(tool)
        let result = try FunctionCallingService.claude.decoder.decode(FunctionTool.self, from: jsonData)

        XCTAssertEqual(result.service, .claude)
        XCTAssertEqual(result.type, .none)
        XCTAssertEqual(result.function.name, "getHTML")
        XCTAssertEqual(result.function.service, .claude)
        XCTAssertEqual(result.function.description, "This is description for `getHTML` method.")
        XCTAssertEqual(result.function.inputSchema.type, .object)
        XCTAssertEqual(result.function.inputSchema.properties?.count, 1)
        let urlString = try XCTUnwrap(result.function.inputSchema.properties?["urlString"])
        XCTAssertEqual(urlString.type, .string)
        XCTAssertEqual(urlString.description, "This is description for `urlString` property")
        XCTAssertEqual(urlString.nullable, false)
        XCTAssertEqual(result.function.inputSchema.requiredProperties, ["urlString"])
    }

    // MARK: ChatGPT

    func testEncodingFunctionForChatGPT() throws {
        let tool = FunctionTool(service: .chatGPT, function: Self.getHTML(service: .chatGPT))
        let jsonData = try FunctionCallingService.chatGPT.encoder.encode(tool)
        if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            // swiftlint:disable:next force_cast
            XCTAssertEqual(dictionary["type"] as! String, "function")

            let tool = try XCTUnwrap(dictionary["function"] as? [String: Any])
            // swiftlint:disable:next force_cast
            XCTAssertEqual(tool["name"] as! String, "getHTML")
            // swiftlint:disable:next force_cast
            XCTAssertEqual(tool["description"] as! String, "This is description for `getHTML` method.")

            let parameters = try XCTUnwrap(tool["parameters"] as? [String: Any])
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

    func testEncodingFunctionsForChatGPT() throws {
        let tools = [
            FunctionTool(service: .chatGPT, function: Self.getHTML(service: .chatGPT)),
            FunctionTool(service: .chatGPT, function: Self.timeOfDay(service: .chatGPT))
        ]

        let jsonData = try FunctionCallingService.chatGPT.encoder.encode(tools)
        if let array = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
            XCTAssertEqual(array.count, 2)

            if let getHTML = array.first {
                let tool = try XCTUnwrap(getHTML["function"] as? [String: Any])
                // swiftlint:disable:next force_cast
                XCTAssertEqual(tool["name"] as! String, "getHTML")
                // swiftlint:disable:next force_cast
                XCTAssertEqual(tool["description"] as! String, "This is description for `getHTML` method.")

                let parameters = try XCTUnwrap(tool["parameters"] as? [String: Any])
                // swiftlint:disable:next force_cast
                XCTAssertEqual(parameters["type"] as! String, "object")

                let properties = try XCTUnwrap(parameters["properties"] as? [String: Any])
                XCTAssertEqual(properties.keys.count, 1)
                XCTAssertEqual(properties.keys.first, "urlString")

                let requiredProperties = try XCTUnwrap(parameters["required"] as? [String])
                XCTAssertEqual(requiredProperties.count, 1)
                XCTAssertEqual(requiredProperties.first, "urlString")
            }

            if let timeOfDay = array.last {
                let tool = try XCTUnwrap(timeOfDay["function"] as? [String: Any])
                // swiftlint:disable:next force_cast
                XCTAssertEqual(tool["name"] as! String, "timeOfDay")
                // swiftlint:disable:next force_cast
                XCTAssertEqual(tool["description"] as! String, "This is description for `timeOfDay` method.")

                let parameters = try XCTUnwrap(tool["parameters"] as? [String: Any])
                // swiftlint:disable:next force_cast
                XCTAssertEqual(parameters["type"] as! String, "object")

                let properties = try XCTUnwrap(parameters["properties"] as? [String: Any])
                XCTAssertEqual(properties.keys.count, 2)
                XCTAssertTrue(properties.keys.contains(where: { $0 == "timeZone"}))
                XCTAssertTrue(properties.keys.contains(where: { $0 == "DST"}))

                let requiredProperties = try XCTUnwrap(parameters["required"] as? [String])
                XCTAssertEqual(requiredProperties.count, 1)
                XCTAssertEqual(requiredProperties.first, "timeZone")
            }
        } else {
            XCTFail("JSON data should be selialized into array")
        }
    }

    func testDecodingFunctionChatGPT() throws {
        let tool = FunctionTool(service: .chatGPT, function: Self.getHTML(service: .chatGPT))
        let jsonData = try FunctionCallingService.chatGPT.encoder.encode(tool)
        let result = try FunctionCallingService.chatGPT.decoder.decode(FunctionTool.self, from: jsonData)

        XCTAssertEqual(result.service, .chatGPT)
        XCTAssertEqual(result.type, .function)
        XCTAssertEqual(result.function.name, "getHTML")
        XCTAssertEqual(result.function.service, .chatGPT)
        XCTAssertEqual(result.function.description, "This is description for `getHTML` method.")
        XCTAssertEqual(result.function.inputSchema.type, .object)
        XCTAssertEqual(result.function.inputSchema.properties?.count, 1)
        let urlString = try XCTUnwrap(result.function.inputSchema.properties?["urlString"])
        XCTAssertEqual(urlString.type, .string)
        XCTAssertEqual(urlString.description, "This is description for `urlString` property")
        XCTAssertEqual(urlString.nullable, false)
        XCTAssertEqual(result.function.inputSchema.requiredProperties, ["urlString"])
    }

    // MARK: Llama

    func testEncodingFunctionForLlama() throws {
        let tool = FunctionTool(service: .llamaOrGemini, function: Self.getHTML(service: .llamaOrGemini))
        let jsonData = try FunctionCallingService.llamaOrGemini.encoder.encode(tool)
        if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            // swiftlint:disable:next force_cast
            XCTAssertEqual(dictionary["name"] as! String, "getHTML")
            // swiftlint:disable:next force_cast
            XCTAssertEqual(dictionary["description"] as! String, "This is description for `getHTML` method.")

            let inputSchema = try XCTUnwrap(dictionary["parameters"] as? [String: Any])
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

    func testEncodingFunctionsForLlama() throws {
        let tools = [
            FunctionTool(service: .llamaOrGemini, function: Self.getHTML(service: .llamaOrGemini)),
            FunctionTool(service: .llamaOrGemini, function: Self.timeOfDay(service: .llamaOrGemini))
        ]

        let jsonData = try FunctionCallingService.llamaOrGemini.encoder.encode(tools)
        if let array = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
            XCTAssertEqual(array.count, 2)

            if let getHTML = array.first {
                // swiftlint:disable:next force_cast
                XCTAssertEqual(getHTML["name"] as! String, "getHTML")
                // swiftlint:disable:next force_cast
                XCTAssertEqual(getHTML["description"] as! String, "This is description for `getHTML` method.")

                let inputSchema = try XCTUnwrap(getHTML["parameters"] as? [String: Any])
                // swiftlint:disable:next force_cast
                XCTAssertEqual(inputSchema["type"] as! String, "object")

                let properties = try XCTUnwrap(inputSchema["properties"] as? [String: Any])
                XCTAssertEqual(properties.keys.count, 1)
                XCTAssertEqual(properties.keys.first, "urlString")

                let requiredProperties = try XCTUnwrap(inputSchema["required"] as? [String])
                XCTAssertEqual(requiredProperties.count, 1)
                XCTAssertEqual(requiredProperties.first, "urlString")
            }

            if let timeOfDay = array.last {
                // swiftlint:disable:next force_cast
                XCTAssertEqual(timeOfDay["name"] as! String, "timeOfDay")
                // swiftlint:disable:next force_cast
                XCTAssertEqual(timeOfDay["description"] as! String, "This is description for `timeOfDay` method.")

                let inputSchema = try XCTUnwrap(timeOfDay["parameters"] as? [String: Any])
                // swiftlint:disable:next force_cast
                XCTAssertEqual(inputSchema["type"] as! String, "object")

                let properties = try XCTUnwrap(inputSchema["properties"] as? [String: Any])
                XCTAssertEqual(properties.keys.count, 2)
                XCTAssertTrue(properties.keys.contains(where: { $0 == "timeZone"}))
                XCTAssertTrue(properties.keys.contains(where: { $0 == "DST"}))

                let requiredProperties = try XCTUnwrap(inputSchema["required"] as? [String])
                XCTAssertEqual(requiredProperties.count, 1)
                XCTAssertEqual(requiredProperties.first, "timeZone")
            }
        } else {
            XCTFail("JSON data should be selialized into arrat")
        }
    }

    func testDecodingFunctionLlama() throws {
        let tool = FunctionTool(service: .llamaOrGemini, function: Self.getHTML(service: .llamaOrGemini))
        let jsonData = try FunctionCallingService.llamaOrGemini.encoder.encode(tool)
        let result = try FunctionCallingService.llamaOrGemini.decoder.decode(FunctionTool.self, from: jsonData)

        XCTAssertEqual(result.service, .llamaOrGemini)
        XCTAssertEqual(result.type, .none)
        XCTAssertEqual(result.function.name, "getHTML")
        XCTAssertEqual(result.function.service, .llamaOrGemini)
        XCTAssertEqual(result.function.description, "This is description for `getHTML` method.")
        XCTAssertEqual(result.function.inputSchema.type, .object)
        XCTAssertEqual(result.function.inputSchema.properties?.count, 1)
        let urlString = try XCTUnwrap(result.function.inputSchema.properties?["urlString"])
        XCTAssertEqual(urlString.type, .string)
        XCTAssertEqual(urlString.description, "This is description for `urlString` property")
        XCTAssertEqual(urlString.nullable, false)
        XCTAssertEqual(result.function.inputSchema.requiredProperties, ["urlString"])
    }
}
