rootProject.name = "dyte_core_android"
dependencyResolutionManagement {
    repositories {
        if (providers.gradleProperty("localBuild").isPresent) {
            includeBuild("../../../mobile-core-bridge") {
                dependencySubstitution {
                    substitute(module("com.cloudflare.realtimekit:mobile-core-bridge")).using(project(":shared"))
                }
            }
        }
    }
}
