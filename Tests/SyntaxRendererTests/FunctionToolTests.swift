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

    func testEncodingFunctionForClaude() throws {
        let tool = FunctionTool(service: .claude, function: Self.getHTML())
        let jsonData = try FunctionCallingEncoder.encode(tool)
        if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            XCTAssertEqual(dictionary["name"] as! String, "getHTML")
            XCTAssertEqual(dictionary["description"] as! String, "This is description for `getHTML` method.")

            let inputSchema = try XCTUnwrap(dictionary["input_schema"] as? [String: Any])
            XCTAssertEqual(inputSchema["type"] as! String, "object")

            let properties = try XCTUnwrap(inputSchema["properties"] as? [String: Any])
            XCTAssertEqual(properties.keys.count, 1)
            XCTAssertEqual(properties.keys.first, "urlString")

            let requiredProperties = try XCTUnwrap(inputSchema["required"] as? [String])
            XCTAssertEqual(requiredProperties.count, 1)
            XCTAssertEqual(requiredProperties.first, "urlString")
        } else {
            XCTFail()
        }
    }

    func testEncodingFunctionsForClaude() throws {
        let tools = [
            FunctionTool(service: .claude, function: Self.getHTML()),
            FunctionTool(service: .claude, function: Self.timeOfDay())
        ]
        let jsonData = try FunctionCallingEncoder.encode(tools)
        if let array = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
            XCTAssertEqual(array.count, 2)
            
            if let getHTML = array.first {
                XCTAssertEqual(getHTML["name"] as! String, "getHTML")
                XCTAssertEqual(getHTML["description"] as! String, "This is description for `getHTML` method.")

                let inputSchema = try XCTUnwrap(getHTML["input_schema"] as? [String: Any])
                XCTAssertEqual(inputSchema["type"] as! String, "object")

                let properties = try XCTUnwrap(inputSchema["properties"] as? [String: Any])
                XCTAssertEqual(properties.keys.count, 1)
                XCTAssertEqual(properties.keys.first, "urlString")

                let requiredProperties = try XCTUnwrap(inputSchema["required"] as? [String])
                XCTAssertEqual(requiredProperties.count, 1)
                XCTAssertEqual(requiredProperties.first, "urlString")
            }

            if let timeOfDay = array.last {
                XCTAssertEqual(timeOfDay["name"] as! String, "timeOfDay")
                XCTAssertEqual(timeOfDay["description"] as! String, "This is description for `timeOfDay` method.")

                let inputSchema = try XCTUnwrap(timeOfDay["input_schema"] as? [String: Any])
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
            XCTFail()
        }
    }

    func testEncodingFunctionForChatGPT() throws {
        let tool = FunctionTool(service: .chatGPT, function: Self.getHTML(service: .chatGPT))
        let jsonData = try FunctionCallingEncoder.encode(tool)
        if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            XCTAssertEqual(dictionary["type"] as! String, "function")

            let tool = try XCTUnwrap(dictionary["function"] as? [String: Any])
            XCTAssertEqual(tool["name"] as! String, "getHTML")
            XCTAssertEqual(tool["description"] as! String, "This is description for `getHTML` method.")

            let parameters = try XCTUnwrap(tool["parameters"] as? [String: Any])
            XCTAssertEqual(parameters["type"] as! String, "object")

            let properties = try XCTUnwrap(parameters["properties"] as? [String: Any])
            XCTAssertEqual(properties.keys.count, 1)
            XCTAssertEqual(properties.keys.first, "urlString")

            let requiredProperties = try XCTUnwrap(parameters["required"] as? [String])
            XCTAssertEqual(requiredProperties.count, 1)
            XCTAssertEqual(requiredProperties.first, "urlString")
        } else {
            XCTFail()
        }
    }

    func testEncodingFunctionsForChatGPT() throws {
        let tools = [
            FunctionTool(service: .chatGPT, function: Self.getHTML(service: .chatGPT)),
            FunctionTool(service: .chatGPT, function: Self.timeOfDay(service: .chatGPT))
        ]
        let jsonData = try FunctionCallingEncoder.encode(tools)
        if let array = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
            XCTAssertEqual(array.count, 2)
            
            if let getHTML = array.first {
                let tool = try XCTUnwrap(getHTML["function"] as? [String: Any])
                XCTAssertEqual(tool["name"] as! String, "getHTML")
                XCTAssertEqual(tool["description"] as! String, "This is description for `getHTML` method.")

                let parameters = try XCTUnwrap(tool["parameters"] as? [String: Any])
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
                XCTAssertEqual(tool["name"] as! String, "timeOfDay")
                XCTAssertEqual(tool["description"] as! String, "This is description for `timeOfDay` method.")

                let parameters = try XCTUnwrap(tool["parameters"] as? [String: Any])
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
            XCTFail()
        }
    }

    func testDecodingFunctionClaude() throws {
        let tool = FunctionTool(service: .claude, function: Self.getHTML())
        let jsonData = try FunctionCallingEncoder.encode(tool)
        let result = try FunctionCallingDecoder.decode(FunctionTool.self, from: jsonData)

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

    func testDecodingFunctionChatGPT() throws {
        let tool = FunctionTool(service: .chatGPT, function: Self.getHTML(service: .chatGPT))
        let jsonData = try FunctionCallingEncoder.encode(tool)
        let result = try FunctionCallingDecoder.decode(FunctionTool.self, from: jsonData)

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
}
