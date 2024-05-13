//
//  DeclGroupSyntaxTests.swift
//  
//
//  Created by Fumito Ito on 2024/05/31.
//

import XCTest
import SwiftSyntax
import SwiftParser
@testable import SyntaxParser

final class DeclGroupSyntaxTests: XCTestCase {
    func testFunctionsReturnsListOfFunctionDeclSyntaxOfClass() throws {
        let classString = """
        class Sample {
            let sampleText: String
            static let sampleInt: Int = 2

            init(sampleText: String) {
                self.sampleText = sampleText
            }

            func getText() -> String {
                return sampleText
            }

            static func getInt(defaultValue: Int?) -> Int {
                guard let defaultValue = defaultValue else {
                    return Self.sampleInt
                }

                return defaultValue
            }
        }
        """

        let source = Parser.parse(source: classString)
        guard let functions = source.statements.first?.item.as(ClassDeclSyntax.self)?.functions else {
            XCTFail("Cannot get list of functions from class")
            return
        }

        XCTAssertEqual(functions.count, 2)
    }

    func testFunctionsReturnsListOfFunctionDeclSyntaxOfStruct() throws {
        let structString = """
        struct Sample {
            let sampleText: String
            static let sampleInt: Int = 2

            init(sampleText: String) {
                self.sampleText = sampleText
            }

            func getText() -> String {
                return sampleText
            }

            static func getInt(defaultValue: Int?) -> Int {
                guard let defaultValue = defaultValue else {
                    return Self.sampleInt
                }

                return defaultValue
            }
        }
        """

        let source = Parser.parse(source: structString)
        guard let functions = source.statements.first?.item.as(StructDeclSyntax.self)?.functions else {
            XCTFail("Cannot get list of functions from class")
            return
        }

        XCTAssertEqual(functions.count, 2)
    }

    func testFunctionsReturnsListOfFunctionDeclSyntaxOfClassWithInnerClassFunction() throws {
        let classString = """
        class Sample {
            enum SampleEnum {
                static func getString() -> String {
                    return "This is string"
                }
            }

            let sampleText: String
            static let sampleInt: Int = 2
            let sampleFunction: (String) -> String = { $0 }

            init(sampleText: String) {
                self.sampleText = sampleText
            }

            func getText() -> String {
                return sampleText
            }

            static func getInt(defaultValue: Int?) -> Int {
                guard let defaultValue = defaultValue else {
                    return Self.sampleInt
                }

                return defaultValue
            }
        }
        """

        let source = Parser.parse(source: classString)
        guard let functions = source.statements.first?.item.as(ClassDeclSyntax.self)?.functions else {
            XCTFail("Cannot get list of functions from class")
            return
        }

        XCTAssertEqual(functions.count, 2)
    }
}
