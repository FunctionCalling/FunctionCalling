//
//  FunctionDeclSyntaxTests.swift
//  
//
//  Created by Fumito Ito on 2024/05/31.
//

import XCTest
import SwiftSyntax
import SwiftParser
@testable import SyntaxParser

final class FunctionDeclSyntaxTests: XCTestCase {
    static let classString = """
    class Sample {
        /// Get the string
        func getString() -> String {
            return "getString"
        }

        /// Get the int
        ///
        /// - Parameter defaultValue: default value to get
        /// - Returns: default value or integer
        func getInt(defaultValue: Int?) -> Int? {
            return defaultValue
        }

        /// get the URL of string
        ///
        /// This is the callable function
        ///
        /// - Parameter urlString: string to get URL object
        /// - Returns: URL object with passed string
        @CallableFunction(.claude)
        func getURL(with urlString: String) -> URL {
            return URL(string: urlString)!
        }

        @Observable
        func getSomething(with someString: String?, _ someInt: Int) -> Bool {
            return true
        }

        func getFromArray(_ array: [String]) -> [String] {
            return []
        }

        @CallableFunction(.claude)
        /// get anything from string
        ///
        /// - Returns: anything string
        static func getAnything() -> String {
            return "anything"
        }

        @CallableFunction(.claude)
        /// get everything from string
        ///
        /// - Returns: everything string
        func getEverything() -> String {
            return "everything"
        }
    }
    """

    func testDetectReturnTypeValidation() {
        let source = Parser.parse(source: Self.classString)
        guard let functions = source.statements.first?.item.as(ClassDeclSyntax.self)?.functions else {
            XCTFail("Cannot get list of functions from class")
            return
        }

        XCTAssertTrue(functions[0].isValidReturnType)
        XCTAssertFalse(functions[1].isValidReturnType)
        XCTAssertTrue(functions[2].isValidReturnType)
        XCTAssertTrue(functions[3].isValidReturnType)
        XCTAssertTrue(functions[4].isValidReturnType)
        XCTAssertTrue(functions[5].isValidReturnType)
        XCTAssertTrue(functions[6].isValidReturnType)
    }

    func testDetectStaticFunction() {
        let source = Parser.parse(source: Self.classString)
        guard let functions = source.statements.first?.item.as(ClassDeclSyntax.self)?.functions else {
            XCTFail("Cannot get list of functions from class")
            return
        }

        XCTAssertFalse(functions[0].isStatic)
        XCTAssertFalse(functions[1].isStatic)
        XCTAssertFalse(functions[2].isStatic)
        XCTAssertFalse(functions[3].isStatic)
        XCTAssertFalse(functions[4].isStatic)
        XCTAssertTrue(functions[5].isStatic)
        XCTAssertFalse(functions[6].isStatic)
    }

    func testDetectNameOfFunctions() {
        let source = Parser.parse(source: Self.classString)
        guard let functions = source.statements.first?.item.as(ClassDeclSyntax.self)?.functions else {
            XCTFail("Cannot get list of functions from class")
            return
        }

        XCTAssertEqual(functions[0].nameText, "getString")
        XCTAssertEqual(functions[1].nameText, "getInt")
        XCTAssertEqual(functions[2].nameText, "getURL")
        XCTAssertEqual(functions[3].nameText, "getSomething")
        XCTAssertEqual(functions[4].nameText, "getFromArray")
        XCTAssertEqual(functions[5].nameText, "getAnything")
        XCTAssertEqual(functions[6].nameText, "getEverything")
    }

    func testDetectNumberOfParametersOfFunctions() {
        let source = Parser.parse(source: Self.classString)
        guard let functions = source.statements.first?.item.as(ClassDeclSyntax.self)?.functions else {
            XCTFail("Cannot get list of functions from class")
            return
        }

        XCTAssertEqual(functions[0].parameters.count, 0)
        XCTAssertEqual(functions[1].parameters.count, 1)
        XCTAssertEqual(functions[2].parameters.count, 1)
        XCTAssertEqual(functions[3].parameters.count, 2)
        XCTAssertEqual(functions[4].parameters.count, 1)
        XCTAssertEqual(functions[5].parameters.count, 0)
        XCTAssertEqual(functions[6].parameters.count, 0)
    }

    func testDetectMetadataOfParametersOfFunctions() throws {
        let source = Parser.parse(source: Self.classString)
        guard let functions = source.statements.first?.item.as(ClassDeclSyntax.self)?.functions else {
            XCTFail("Cannot get list of functions from class")
            return
        }

        XCTAssertEqual(functions[0].parameters.first?.name, nil)
        XCTAssertEqual(try functions[0].parameters.first?.typeName, nil)
        XCTAssertEqual(functions[0].parameters.first?.isOptional, nil)
        XCTAssertEqual(functions[0].parameters.first?.isArray, nil)

        XCTAssertEqual(functions[1].parameters.first?.name, "defaultValue")
        XCTAssertEqual(try functions[1].parameters.first?.typeName, "Int")
        XCTAssertEqual(functions[1].parameters.first?.isOptional, true)
        XCTAssertEqual(functions[1].parameters.first?.isArray, false)

        XCTAssertEqual(functions[2].parameters.first?.name, "with")
        XCTAssertEqual(try functions[2].parameters.first?.typeName, "String")
        XCTAssertEqual(functions[2].parameters.first?.isOptional, false)
        XCTAssertEqual(functions[2].parameters.first?.isArray, false)

        XCTAssertEqual(functions[3].parameters.first?.name, "with")
        XCTAssertEqual(try functions[3].parameters.first?.typeName, "String")
        XCTAssertEqual(functions[3].parameters.first?.isOptional, true)
        XCTAssertEqual(functions[3].parameters.first?.isArray, false)

        XCTAssertEqual(functions[3].parameters[1].name, "_")
        XCTAssertEqual(try functions[3].parameters[1].typeName, "Int")
        XCTAssertEqual(functions[3].parameters[1].isOptional, false)
        XCTAssertEqual(functions[3].parameters[1].isArray, false)

        XCTAssertEqual(functions[4].parameters.first?.name, "_")
        XCTAssertEqual(try functions[4].parameters.first?.typeName, "String")
        XCTAssertEqual(functions[4].parameters.first?.isOptional, false)
        XCTAssertEqual(functions[4].parameters.first?.isArray, true)

        XCTAssertEqual(functions[5].parameters.first?.name, nil)
        XCTAssertEqual(try functions[5].parameters.first?.typeName, nil)
        XCTAssertEqual(functions[5].parameters.first?.isOptional, nil)
        XCTAssertEqual(functions[5].parameters.first?.isArray, nil)

        XCTAssertEqual(functions[6].parameters.first?.name, nil)
        XCTAssertEqual(try functions[6].parameters.first?.typeName, nil)
        XCTAssertEqual(functions[6].parameters.first?.isOptional, nil)
        XCTAssertEqual(functions[6].parameters.first?.isArray, nil)
    }

    func testDetectIsCallableOfFunctions() {
        let source = Parser.parse(source: Self.classString)
        guard let functions = source.statements.first?.item.as(ClassDeclSyntax.self)?.functions else {
            XCTFail("Cannot get list of functions from class")
            return
        }

        XCTAssertFalse(functions[0].isCallable)
        XCTAssertFalse(functions[1].isCallable)
        XCTAssertTrue(functions[2].isCallable)
        XCTAssertFalse(functions[3].isCallable)
        XCTAssertFalse(functions[4].isCallable)
        XCTAssertTrue(functions[5].isCallable)
        XCTAssertTrue(functions[6].isCallable)
    }

    func testGetDocumentationCommentOfFunctions() {
        let source = Parser.parse(source: Self.classString)
        guard let functions = source.statements.first?.item.as(ClassDeclSyntax.self)?.functions else {
            XCTFail("Cannot get list of functions from class")
            return
        }

        XCTAssertEqual(functions[0].documentationComment?.raw, "Get the string")
        XCTAssertEqual(functions[1].documentationComment?.raw, """
        Get the int

        - Parameter defaultValue: default value to get
        - Returns: default value or integer
        """)
        XCTAssertEqual(functions[2].documentationComment?.raw, """
        get the URL of string

        This is the callable function

        - Parameter urlString: string to get URL object
        - Returns: URL object with passed string
        """)
        XCTAssertEqual(functions[3].documentationComment?.raw, "")
        XCTAssertEqual(functions[4].documentationComment?.raw, "")
        XCTAssertEqual(functions[5].documentationComment?.raw, """
        get anything from string

        - Returns: anything string
        """)
        XCTAssertEqual(functions[6].documentationComment?.raw, """
        get everything from string

        - Returns: everything string
        """)
    }
}
