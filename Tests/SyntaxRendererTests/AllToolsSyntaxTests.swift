//
//  AllToolsSyntaxTests.swift
//  
//
//  Created by Fumito Ito on 2024/05/24.
//

import XCTest
import CommonModules
@testable import SyntaxRenderer

final class AllToolsSyntaxTests: XCTestCase {
    static var getHTML: Tool {
        .init(
            service: .claude,
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

    static var timeOfDay: Tool {
        .init(
            service: .claude,
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

    static var getSomething: Tool {
        .init(
            service: .claude,
            name: "getSomething",
            description: "This is description for `getSomething` method.",
            inputSchema: .init(
                type: .object,
                properties: [
                    "someText": .init(
                        type: .array,
                        description: "This is description for `timeOfDay` property",
                        nullable: false,
                        items: .init(
                            type: .string
                        )
                    )
                ],
                requiredProperties: [
                    "someText"
                ]
            )
        )
    }

    func testVariableDefinition() throws {
        let object = [FunctionTool(service: .claude, function: Self.getHTML)]

        let filledTemplate = try AllToolsJSONStringSyntax.render(with: object, service: .claude)
        let lines = filledTemplate.split(separator: "\n")

        XCTAssertEqual(lines.first, "var allToolsJSONString: String {")
        XCTAssertEqual(lines[1], """
            \"""
        """)
        XCTAssertEqual(lines[lines.count - 2], """
            \"""
        """)
        XCTAssertEqual(lines.last, "}")
    }

    func testFillingTemplateWithSingleFunction() throws {
        let object = [FunctionTool(service: .claude, function: Self.getHTML)]

        let filledTemplate = try AllToolsJSONStringSyntax.render(with: object, service: .claude)
        let jsonString = filledTemplate.split(separator: "\n").dropFirst(2).dropLast(2).joined(separator: "\n")

        let jsonData = try XCTUnwrap(jsonString.data(using: .utf8))
        let tools = try FunctionCallingService.claude.decoder.decode([Tool].self, from: jsonData)

        XCTAssertEqual(tools.count, 1)
        let getHTML = try XCTUnwrap(tools.first)
        XCTAssertEqual(getHTML.name, "getHTML")
        XCTAssertEqual(getHTML.description, "This is description for `getHTML` method.")
        XCTAssertEqual(getHTML.inputSchema.properties?.count, 1)
        XCTAssertEqual(getHTML.inputSchema.requiredProperties?.count, 1)
        XCTAssertEqual(getHTML.inputSchema.requiredProperties?.first, "urlString")
        let urlString = try XCTUnwrap(getHTML.inputSchema.properties?["urlString"])
        XCTAssertEqual(urlString.type, .string)
        XCTAssertEqual(urlString.description, "This is description for `urlString` property")
        XCTAssertEqual(urlString.nullable, false)
    }

    func testFillingTemplateWithMultipleArgumentsFunction() throws {
        let object = [FunctionTool(service: .claude, function: Self.timeOfDay)]

        let filledTemplate = try AllToolsJSONStringSyntax.render(with: object, service: .claude)
        let jsonString = filledTemplate.split(separator: "\n").dropFirst(2).dropLast(2).joined(separator: "\n")

        let jsonData = try XCTUnwrap(jsonString.data(using: .utf8))
        let tools = try FunctionCallingService.claude.decoder.decode([Tool].self, from: jsonData)

        XCTAssertEqual(tools.count, 1)
        let timeOfDay = try XCTUnwrap(tools.first)
        XCTAssertEqual(timeOfDay.name, "timeOfDay")
        XCTAssertEqual(timeOfDay.description, "This is description for `timeOfDay` method.")
        XCTAssertEqual(timeOfDay.inputSchema.properties?.count, 2)
        XCTAssertEqual(timeOfDay.inputSchema.requiredProperties?.count, 1)
        XCTAssertEqual(timeOfDay.inputSchema.requiredProperties?.first, "timeZone")
        let timeZone = try XCTUnwrap(timeOfDay.inputSchema.properties?["timeZone"])
        XCTAssertEqual(timeZone.type, .string)
        XCTAssertEqual(timeZone.description, "This is description for `timeOfDay` property")
        XCTAssertEqual(timeZone.nullable, false)
        let DST = try XCTUnwrap(timeOfDay.inputSchema.properties?["DST"])
        XCTAssertEqual(DST.type, .string)
        XCTAssertEqual(DST.description, "This is description for `DST` property")
        XCTAssertEqual(DST.nullable, true)
    }

    func testFillingTemplateWithMultipleFunctions() throws {
        let object = [
            FunctionTool(service: .claude, function: Self.getHTML),
            FunctionTool(service: .claude, function: Self.timeOfDay)
        ]

        let filledTemplate = try AllToolsJSONStringSyntax.render(with: object, service: .claude)
        let jsonString = filledTemplate.split(separator: "\n").dropFirst(2).dropLast(2).joined(separator: "\n")

        let jsonData = try XCTUnwrap(jsonString.data(using: .utf8))
        let tools = try FunctionCallingService.claude.decoder.decode([Tool].self, from: jsonData)

        XCTAssertEqual(tools.count, 2)

        // getHTML
        let getHTML = try XCTUnwrap(tools.first)
        XCTAssertEqual(getHTML.name, "getHTML")
        XCTAssertEqual(getHTML.description, "This is description for `getHTML` method.")
        XCTAssertEqual(getHTML.inputSchema.properties?.count, 1)
        XCTAssertEqual(getHTML.inputSchema.requiredProperties?.count, 1)
        XCTAssertEqual(getHTML.inputSchema.requiredProperties?.first, "urlString")
        let urlString = try XCTUnwrap(getHTML.inputSchema.properties?["urlString"])
        XCTAssertEqual(urlString.type, .string)
        XCTAssertEqual(urlString.description, "This is description for `urlString` property")
        XCTAssertEqual(urlString.nullable, false)

        // timeOfDay
        let timeOfDay = try XCTUnwrap(tools[1])
        XCTAssertEqual(timeOfDay.name, "timeOfDay")
        XCTAssertEqual(timeOfDay.description, "This is description for `timeOfDay` method.")
        XCTAssertEqual(timeOfDay.inputSchema.properties?.count, 2)
        XCTAssertEqual(timeOfDay.inputSchema.requiredProperties?.count, 1)
        XCTAssertEqual(timeOfDay.inputSchema.requiredProperties?.first, "timeZone")
        let timeZone = try XCTUnwrap(timeOfDay.inputSchema.properties?["timeZone"])
        XCTAssertEqual(timeZone.type, .string)
        XCTAssertEqual(timeZone.description, "This is description for `timeOfDay` property")
        XCTAssertEqual(timeZone.nullable, false)
        let DST = try XCTUnwrap(timeOfDay.inputSchema.properties?["DST"])
        XCTAssertEqual(DST.type, .string)
        XCTAssertEqual(DST.description, "This is description for `DST` property")
        XCTAssertEqual(DST.nullable, true)
    }

    func testFillingTemplateWithArrayArgumentFunction() throws {
        let object = [
            FunctionTool(service: .claude, function: Self.getSomething)
        ]

        let filledTemplate = try AllToolsJSONStringSyntax.render(with: object, service: .claude)
        let jsonString = filledTemplate.split(separator: "\n").dropFirst(2).dropLast(2).joined(separator: "\n")

        let jsonData = try XCTUnwrap(jsonString.data(using: .utf8))
        let tools = try FunctionCallingService.claude.decoder.decode([Tool].self, from: jsonData)

        XCTAssertEqual(tools.count, 1)
        let getSomething = try XCTUnwrap(tools.first)
        XCTAssertEqual(getSomething.name, "getSomething")
        XCTAssertEqual(getSomething.description, "This is description for `getSomething` method.")
        XCTAssertEqual(getSomething.inputSchema.properties?.count, 1)
        XCTAssertEqual(getSomething.inputSchema.requiredProperties?.count, 1)
        XCTAssertEqual(getSomething.inputSchema.requiredProperties?.first, "someText")
        let someText = try XCTUnwrap(getSomething.inputSchema.properties?["someText"])
        XCTAssertEqual(someText.type, .array)
        XCTAssertEqual(someText.description, "This is description for `timeOfDay` property")
        XCTAssertEqual(someText.items?.type, .string)
        XCTAssertEqual(someText.nullable, false)
    }
}
