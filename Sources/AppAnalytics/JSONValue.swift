//
//  JSONValue.swift
//  AppAnalytics
//
//  Created by Slava Nehria on 14.05.2026.
//

import Foundation

enum JSONValue: Encodable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case object([String: JSONValue])
    case array([JSONValue])
    case null

    init(_ value: Any) {
        switch value {
        case let value as String:
            self = .string(value)
        case let value as Int:
            self = .int(value)
        case let value as Int64:
            self = .double(Double(value))
        case let value as Double:
            self = .double(value)
        case let value as Float:
            self = .double(Double(value))
        case let value as Bool:
            self = .bool(value)
        case let value as [String: Any]:
            self = .object(value.mapValues { JSONValue($0) })
        case let value as [Any]:
            self = .array(value.map { JSONValue($0) })
        case _ as NSNull:
            self = .null
        default:
            self = .null
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}
