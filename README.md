# AppAnalytics iOS SDK

## Installation via Swift Package Manager

1. Open your iOS project in Xcode.
2. Go to `File` → `Add Package Dependencies...`
3. Enter the package repository URL:
```text
https://github.com/nslllava/AppAnalytics.git
```
4. Select the version you want to use.
5. Add the package to your app target.

After installation, import the SDK:

```swift
import AppAnalytics
```

## Setup

Configure the SDK once when your app starts. The SDK should be configured before sending any events. Replace `YOUR_API_KEY` with your real API key:

### SwiftUI App

```swift
import SwiftUI
import AppAnalytics

@main
struct MyApp: App {

    init() {
        AppAnalytics.configure(apiKey: "YOUR_API_KEY")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### UIKit AppDelegate

```swift
import UIKit
import AppAnalytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        AppAnalytics.configure(apiKey: "YOUR_API_KEY")
        return true
    }
}
```

## Events

Send an event without properties:

```swift
AppAnalytics.logEvent("app_open")
```

Send an event with properties:

```swift
AppAnalytics.logEvent("level_complete", properties: [
    "level": 1,
    "score": 1500,
    "premium": true
])
```
