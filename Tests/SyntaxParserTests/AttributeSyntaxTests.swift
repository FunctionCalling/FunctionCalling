//
//  AttributeSyntaxTests.swift
//  
//
//  Created by Fumito Ito on 2024/06/03.
//

import XCTest
import SwiftSyntax
import SwiftParser
@testable import SyntaxParser

final class AttributeSyntaxTests: XCTestCase {
    func testDetectServicePassedByAttribute() throws {
        let classString = """
        @FunctionCalling(.claude)
        class Sample {
            func getText() -> String {
                return "sample"
            }
        }
        """

        let source = Parser.parse(source: classString)
        guard let classObject = source.statements.first?.item.as(ClassDeclSyntax.self) else {
            XCTFail("Cannot get list of functions from class")
            return
        }

        let attribute = try XCTUnwrap(classObject.attributes.first?.as(AttributeSyntax.self))
        XCTAssertNotNil(attribute.service)
        XCTAssertEqual(attribute.service, .claude)
    }

    func testIgnoreInvalidServicePassedByAttribute() throws {
        let classString = """
        @FunctionCalling(.foobar)
        class Sample {
            func getText() -> String {
                return "sample"
            }
        }
        """

        let source = Parser.parse(source: classString)
        guard let classObject = source.statements.first?.item.as(ClassDeclSyntax.self) else {
            XCTFail("Cannot get list of functions from class")
            return
        }

        let attribute = try XCTUnwrap(classObject.attributes.first?.as(AttributeSyntax.self))
        XCTAssertNil(attribute.service)
    }
}
