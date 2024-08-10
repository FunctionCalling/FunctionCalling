//
//  FunctionParameterSyntaxTests.swift
//  
//
//  Created by 伊藤史 on 2024/08/09.
//

import XCTest
import SwiftSyntax
import SwiftParser
import CommonModules
@testable import SyntaxParser

final class FunctionParameterSyntaxTests: XCTestCase {
    let classString = """
    @FunctionCalling(.claude)
    class Sample {
        func getText() -> String {
            return "sample"
        }

        func concat(words: [String]) -> String {
            return ""
        }

        func parseString(_ string: String) -> String {
            return ""
        }

        func getString(from array: [String]) -> String {
            return ""
        }
    }
    """

    func testGetParameterName() {
        let source = Parser.parse(source: classString)
        guard let functions = source.statements.first?.item.as(ClassDeclSyntax.self)?.functions else {
            XCTFail("Cannot get list of functions from class")
            return
        }

        XCTAssertEqual(functions[0].parameters.count, 0)

        XCTAssertEqual(functions[1].parameters.count, 1)
        XCTAssertEqual(functions[1].parameters.first?.name, "words")
        XCTAssertNil(functions[1].parameters.first?.omittingName)
        XCTAssertEqual(functions[1].parameters.first?.isArray, true)
        XCTAssertEqual(functions[1].parameters.first?.isOptional, false)

        XCTAssertEqual(functions[2].parameters.count, 1)
        XCTAssertEqual(functions[2].parameters.first?.name, "_")
        XCTAssertEqual(functions[2].parameters.first?.omittingName, "string")
        XCTAssertEqual(functions[2].parameters.first?.isArray, false)
        XCTAssertEqual(functions[2].parameters.first?.isOptional, false)

        XCTAssertEqual(functions[3].parameters.count, 1)
        XCTAssertEqual(functions[3].parameters.first?.name, "from")
        XCTAssertEqual(functions[3].parameters.first?.omittingName, "array")
        XCTAssertEqual(functions[3].parameters.first?.isArray, true)
        XCTAssertEqual(functions[3].parameters.first?.isOptional, false)
    }
}
