//
//  AppAnalytics.swift
//  AppAnalytics
//
//  Created by Slava Nehria on 12.05.2026.
//

import Foundation

public enum AppAnalytics {

    private static let client = AnalyticsClient()

    public static func configure(apiKey: String) {
        Task {
            await client.configure(apiKey: apiKey)
        }
    }

    public static func logEvent(
        _ name: String,
        properties: EventProperties = [:]
    ) {
        let properties = properties.mapValues { JSONValue($0) }
        Task {
            await client.logEvent(name, properties: properties)
        }
    }
}
