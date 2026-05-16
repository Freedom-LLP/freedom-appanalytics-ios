// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppAnalytics",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AppAnalytics",
            targets: ["AppAnalytics"]
        ),
    ],
    targets: [
        .target(
            name: "AppAnalytics"
        )
    ]
)
