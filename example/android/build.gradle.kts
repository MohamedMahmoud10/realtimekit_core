allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Some plugins still hardcode an old compileSdk (e.g. flutter_native_splash
// pins compileSdk 31), which fails the AAR-metadata check because their newer
// androidx transitive deps require compileSdk 34+. Bump any lagging Android
// subproject up to the app's level. Purely a build-config fix — unrelated to
// app logic or the meeting SDK.
subprojects {
    fun bumpCompileSdk() {
        when (val ext = extensions.findByName("android")) {
            is com.android.build.api.dsl.LibraryExtension ->
                if ((ext.compileSdk ?: 0) < 34) ext.compileSdk = 36
            is com.android.build.api.dsl.ApplicationExtension ->
                if ((ext.compileSdk ?: 0) < 34) ext.compileSdk = 36
        }
    }
    // The earlier `evaluationDependsOn(":app")` can leave some subprojects
    // already evaluated here, where afterEvaluate would throw — so apply now
    // if evaluated, otherwise defer.
    if (state.executed) bumpCompileSdk() else afterEvaluate { bumpCompileSdk() }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
