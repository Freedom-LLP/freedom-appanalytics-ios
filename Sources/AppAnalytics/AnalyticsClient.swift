//
//  AnalyticsClient.swift
//  AppAnalytics
//
//  Created by Slava Nehria on 12.05.2026.
//

import Foundation

actor AnalyticsClient {

    private let baseURL = "https://api.appanalytics.ai/v1/"
    private var apiKey: String?

    func configure(apiKey: String) {
        self.apiKey = apiKey
    }

    func logEvent(
        _ name: String,
        properties: EventProperties
    ) async {
        guard let apiKey else {
            assertionFailure("AppAnalytics is not configured. Call AppAnalytics.configure(apiKey:) first.")
            return
        }

        let event = Event(
            name: name,
            timestamp: Int64(Date().timeIntervalSince1970 * 1000),
            properties: properties
        )

        do {
            try await send(event, apiKey: apiKey)
        } catch {
#if DEBUG
            print("AppAnalytics failed to send event:", error)
#endif
        }
    }

    private func send(
        _ event: Event,
        apiKey: String
    ) async throws {
        guard let appId = Bundle.main.bundleIdentifier else {
#if DEBUG
            assertionFailure("Missing Bundle Identifier. Ensure your target has a valid bundle identifier.")
#endif
            throw AnalyticsError.missingBundleIdentifier
        }

        let deviceId = await Self.makeDeviceId()
        let platform = "ios"
        let payload = Request(
            appId: appId,
            deviceId: deviceId,
            platform: platform,
            events: [event]
        )

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        let body = try encoder.encode(payload)

        guard let url = URL(string: baseURL + "/events") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = body
        request.timeoutInterval = 15

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        switch http.statusCode {
        case 200...299:
            _ = data
        case 400...499:
            throw AnalyticsError.clientError(status: http.statusCode, data: data)
        case 500...599:
            throw AnalyticsError.serverError(status: http.statusCode, data: data)
        default:
            throw AnalyticsError.unexpectedStatus(status: http.statusCode, data: data)
        }
    }
}

private enum AnalyticsError: Error, CustomStringConvertible {
    case missingBundleIdentifier
    case clientError(status: Int, data: Data)
    case serverError(status: Int, data: Data)
    case unexpectedStatus(status: Int, data: Data)

    var description: String {
        switch self {
        case .missingBundleIdentifier:
            return "Missing Bundle Identifier. Ensure your target has a valid bundle identifier."
        case .clientError(let status, let data):
            return "Client error \(status): \(String(data: data, encoding: .utf8) ?? "<no body>")"
        case .serverError(let status, let data):
            return "Server error \(status): \(String(data: data, encoding: .utf8) ?? "<no body>")"
        case .unexpectedStatus(let status, let data):
            return "Unexpected status \(status): \(String(data: data, encoding: .utf8) ?? "<no body>")"
        }
    }
}

extension AnalyticsClient {

    private static func makeDeviceId() async -> String {
        let defaults = UserDefaults.standard
        let key = "app_analytics_device_id"
        if let existing = defaults.string(forKey: key) {
            return existing
        }
        let new = UUID().uuidString
        defaults.set(new, forKey: key)
        return new
    }
}
