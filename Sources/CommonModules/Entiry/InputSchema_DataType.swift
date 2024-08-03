//
//  InputSchema_DataType.swift
//  
//
//  Created by 伊藤史 on 2024/07/29.
//

import Foundation

/// An enumeration that represents the schema type for Function Calling
public extension InputSchema {
    enum DataType: String, Codable {
        /// A string type contains `byte`, `binary`, `date`, `date-time` and `password` format
        case string
        /// A floating point number type contains `float` and `double` format
        case number
        /// A integer type contains `int32` and `int64` format
        case integer
        /// A boolean type
        case boolean
        /// An array of type
        case array
        /// An object
        case object
    }
}
