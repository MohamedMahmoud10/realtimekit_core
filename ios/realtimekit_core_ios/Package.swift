// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "realtimekit_core_ios",
    platforms: [
        .iOS("13.0"),
    ],
    products: [
        .library(
            name: "realtimekit-core-ios",
            targets: ["realtimekit_core_ios"]
        ),
    ],
    dependencies: [
        // Cloudflare shipped 0.1.6 pointing core-bridge at their INTERNAL
        // GitLab (gitlab.cfdata.org), which is unreachable from the public
        // internet, so SPM resolution fails with a clone timeout on iOS.
        // The public mirror below is what 0.1.2+1..0.1.5+1 used (and the Swift
        // glue here is byte-identical to 0.1.5+1), so this restores a working,
        // publicly-resolvable build. The actual xcframeworks still download
        // from the public CDN (sdk-assets.realtime.cloudflare.com).
        .package(url: "https://github.com/dyte-in/mobile-core-bridge-spm.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "realtimekit_core_ios",
            dependencies: [
                .product(name: "RealtimeKitFlutterCoreKMM", package: "mobile-core-bridge-spm"),
            ],
            path: "./Sources/realtimekit_core_ios",
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
