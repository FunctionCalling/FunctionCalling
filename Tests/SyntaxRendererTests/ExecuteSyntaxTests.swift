//
//  ExecuteSyntaxTests.swift
//  
//
//  Created by 伊藤史 on 2024/05/02.
//

import XCTest
@testable import SyntaxRenderer

final class ExecuteSyntaxTests: XCTestCase {
    static let getHTML = Function(
        methodName: "getHTML",
        parameters: [
            Parameter(name: "urlString", omittingName: nil, required: true, type: "String", isLast: true)
        ],
        isStatic: true
    )

    static let timeOfDay = Function(
        methodName: "timeOfDay",
        parameters: [
            Parameter(name: "timeZone", omittingName: nil, required: true, type: "String", isLast: false),
            Parameter(name: "DST", omittingName: nil, required: true, type: "String", isLast: true)
        ],
        isStatic: true
    )

    static let generateTool = Function(
        methodName: "generateTool",
        parameters: [
            Parameter(name: "from", omittingName: nil, required: false, type: "String", isLast: true)
        ],
        isStatic: false
    )

    static let getFromArray = Function(
        methodName: "getFromArray",
        parameters: [
            .init(name: "_", omittingName: "array", required: true, type: "[String]", isLast: true)
        ],
        isStatic: false
    )

    func testFillingTemplateWithSingleFunction() throws {
        let model = Execute(functions: [Self.getHTML])

        let filledTemplate = try ExecuteSyntax.render(with: model)
        let expect = """
        func execute(methodName: String, parameters: [String: Any]) async -> String {
            do {
                switch methodName {
                case "getHTML":
                    let urlString = parameters["urlString"] as! String
                    return try await Self.getHTML(
                        urlString: urlString
                    ).description
                default:
                    throw FunctionCallingError.unknownFunctionCalled
                }
            } catch let error {
                return error.localizedDescription
            }
        }
        """
        XCTAssertEqual(filledTemplate, expect)
    }

    func testFillingTemplateWithMultipleArgumentsFunction() throws {
        let model = Execute(functions: [Self.timeOfDay])

        let filledTemplate = try ExecuteSyntax.render(with: model)
        let expect = """
        func execute(methodName: String, parameters: [String: Any]) async -> String {
            do {
                switch methodName {
                case "timeOfDay":
                    let timeZone = parameters["timeZone"] as! String
                    let DST = parameters["DST"] as! String
                    return try await Self.timeOfDay(
                        timeZone: timeZone,
                        DST: DST
                    ).description
                default:
                    throw FunctionCallingError.unknownFunctionCalled
                }
            } catch let error {
                return error.localizedDescription
            }
        }
        """
        XCTAssertEqual(filledTemplate, expect)
    }

    func testFillingTemplateWithMultipleFunctions() throws {
        let model = Execute(functions: [
            Self.getHTML,
            Self.timeOfDay
        ])

        let filledTemplate = try ExecuteSyntax.render(with: model)
        let expect = """
        func execute(methodName: String, parameters: [String: Any]) async -> String {
            do {
                switch methodName {
                case "getHTML":
                    let urlString = parameters["urlString"] as! String
                    return try await Self.getHTML(
                        urlString: urlString
                    ).description
                case "timeOfDay":
                    let timeZone = parameters["timeZone"] as! String
                    let DST = parameters["DST"] as! String
                    return try await Self.timeOfDay(
                        timeZone: timeZone,
                        DST: DST
                    ).description
                default:
                    throw FunctionCallingError.unknownFunctionCalled
                }
            } catch let error {
                return error.localizedDescription
            }
        }
        """
        XCTAssertEqual(filledTemplate, expect)
    }

    func testFillingTemplateWithOptionalArgumentFunction() throws {
        let model = Execute(functions: [Self.generateTool])

        let filledTemplate = try ExecuteSyntax.render(with: model)
        let expect = """
        func execute(methodName: String, parameters: [String: Any]) async -> String {
            do {
                switch methodName {
                case "generateTool":
                    let from = parameters["from"] as? String
                    return try await generateTool(
                        from: from
                    ).description
                default:
                    throw FunctionCallingError.unknownFunctionCalled
                }
            } catch let error {
                return error.localizedDescription
            }
        }
        """
        XCTAssertEqual(filledTemplate, expect)
    }

    func testFillingTemplateWithOmmitingArgumentFunction() throws {
        let model = Execute(functions: [Self.getFromArray])

        let filledTemplate = try ExecuteSyntax.render(with: model)
        let expect = """
        func execute(methodName: String, parameters: [String: Any]) async -> String {
            do {
                switch methodName {
                case "getFromArray":
                    let array = parameters["array"] as! [String]
                    return try await getFromArray(
                        array
                    ).description
                default:
                    throw FunctionCallingError.unknownFunctionCalled
                }
            } catch let error {
                return error.localizedDescription
            }
        }
        """
        XCTAssertEqual(filledTemplate, expect)
    }
}
