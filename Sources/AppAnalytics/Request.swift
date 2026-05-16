//
//  Request.swift
//  AppAnalytics
//
//  Created by Slava Nehria on 14.05.2026.
//

import Foundation

struct Request: Encodable {
    let appId: String
    let deviceId: String
    let platform: String
    let events: [Event]

    enum CodingKeys: String, CodingKey {
        case appId = "app_id"
        case deviceId = "device_id"
        case platform
        case events
    }
}
