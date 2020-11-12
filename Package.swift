// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "lynx",
    platforms: [.macOS(.v10_12)],
    products: [
        .executable(name: "lynx", targets: ["lynx"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander", from: "0.9.1"),
        .package(url: "https://github.com/kareman/SwiftShell", from: "5.1.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.46.2"),
        .package(url: "https://github.com/mtynior/ColorizeSwift", from: "1.6.0"),
    ],
    targets: [
        .target(
            name: "lynx",
            dependencies: ["FileUtils", "GitUtils", "XcodeBuildUtils", "Commander", "SwiftShell", "ColorizeSwift"]
        ),
        .target(name: "Command", dependencies: ["SwiftShell"]),
        .target(name: "FileUtils", dependencies: ["Command"]),
        .target(name: "GitUtils", dependencies: ["Command"]),
        .target(name: "XcodeBuildUtils", dependencies: ["Command"]),
    ]
)
