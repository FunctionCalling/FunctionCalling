//
//  Trivia+Extension.swift
//
//
//  Created by Fumito Ito on 2024/05/31.
//

import Foundation
import SwiftSyntax

extension Trivia {
    /// A computed property that returns the documentation comments as a single string.
    var toDocCommentString: String {
        pieces.compactMap { piece in
            switch piece {
            case .docLineComment(let str), .docBlockComment(let str):
                return str
            default:
                return nil
            }
        }.joined(separator: "\n")
    }

    /// A computed property that indicates whether the trivia contains any documentation comments.
    var containsDocComment: Bool {
        pieces.contains { piece in
            switch piece {
            case .docLineComment, .docBlockComment:
                return true
            default:
                return false
            }
        }
    }
}
