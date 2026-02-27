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
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
plugins {
    // Esta versión la aceptó en el paso anterior
    id("com.android.application") version "8.11.1" apply false
    
    // AQUÍ EL CAMBIO: Ponemos la 2.2.20 que su terminal exige
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    
    id("dev.flutter.flutter-gradle-plugin") apply false
    
    // Nuestra pieza de Firebase
    id("com.google.gms.google-services") version "4.4.1" apply false
}