//
//  String+Extension.swift
//  
//
//  Created by 伊藤史 on 2024/06/18.
//

import Foundation

extension String {
    /// A computed property that returns a new string with all empty lines removed.
    var emptyLineRemoved: Self {
        let lines = split(separator: "\n", omittingEmptySubsequences: false)

        let filteredLines = lines.filter { line in
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            return !trimmedLine.isEmpty
        }

        return filteredLines.joined(separator: "\n")
    }
}
