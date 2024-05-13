//
//  Trivia+Extension.swift
//
//
//  Created by Fumito Ito on 2024/05/31.
//

import Foundation
import SwiftSyntax

extension Trivia {
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
