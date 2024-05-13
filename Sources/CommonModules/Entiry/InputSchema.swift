//
//  Schema.swift
//
//
//  Created by 伊藤史 on 2024/07/24.
//

import Foundation

public class InputSchema {
    public let type: DataType
    public let format: String?
    public let description: String?
    public let nullable: Bool?
    public let enumValues: [String]?
    public let items: InputSchema?
    public let properties: [String: InputSchema]?
    public let requiredProperties: [String]?

    public init(
        type: DataType,
        format: String? = nil,
        description: String? = nil,
        nullable: Bool? = nil,
        enumValues: [String]? = nil,
        items: InputSchema? = nil,
        properties: [String: InputSchema]? = nil,
        requiredProperties: [String]? = nil
    ) {
        self.type = type
        self.format = format
        self.description = description
        self.nullable = nullable
        self.enumValues = enumValues
        self.items = items
        self.properties = properties
        self.requiredProperties = requiredProperties
    }

    required public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(DataType.self, forKey: .type)
        self.format = try? container.decode(String.self, forKey: .format)
        self.description = try? container.decode(String.self, forKey: .description)
        self.nullable = try? container.decode(Bool.self, forKey: .nullable)
        self.enumValues = try? container.decode([String].self, forKey: .enumValues)
        self.items = try? container.decode(InputSchema.self, forKey: .items)
        self.properties = try? container.decode([String: InputSchema].self, forKey: .properties)
        self.requiredProperties = try? container.decode([String].self, forKey: .requiredProperties)
    }
}

extension InputSchema {
    enum CodingKeys: String, CodingKey {
        case type
        case format
        case description
        case nullable
        case enumValues = "enum"
        case items
        case properties
        case requiredProperties = "required"
    }
}

extension InputSchema: Encodable {}

extension InputSchema: Decodable {}
