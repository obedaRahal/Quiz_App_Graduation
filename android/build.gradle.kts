allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")

    configurations.all {
        resolutionStrategy {
            force(
                "androidx.lifecycle:lifecycle-common:2.7.0",
                "androidx.lifecycle:lifecycle-common-java8:2.7.0",
                "androidx.collection:collection:1.3.0",
                "androidx.collection:collection-ktx:1.3.0"
            )
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}