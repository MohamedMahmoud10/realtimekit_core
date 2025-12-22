pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()

        // Use composite builds for local development
        if (providers.gradleProperty("localBuild").isPresent) {
            includeBuild("../../../mobile-core") {
                dependencySubstitution {
                    substitute(module("com.cloudflare.realtimekit:core")).using(project(":core"))
                }
            }
            includeBuild("../../../mobile-core-bridge") {
                dependencySubstitution {
                    substitute(module("com.cloudflare.realtimekit:mobile-core-bridge")).using(project(":shared"))
                }
            }
        }
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.13.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.10" apply false
}

include(":app")
