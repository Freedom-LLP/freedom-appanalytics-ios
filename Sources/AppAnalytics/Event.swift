//
//  Event.swift
//  AppAnalytics
//
//  Created by Slava Nehria on 14.05.2026.
//

import Foundation

public typealias EventProperties = [String : Any]

struct Event: Encodable {
    let name: String
    let timestamp: Int64
    let properties: [String: JSONValue]

    init(
        name: String,
        timestamp: Int64,
        properties: EventProperties = [:]
    ) {
        self.name = name
        self.timestamp = timestamp
        self.properties = properties.mapValues { JSONValue($0) }
    }
}
