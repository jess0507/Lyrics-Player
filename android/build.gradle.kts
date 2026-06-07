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

// 部分舊外掛（如 isar_flutter_libs 3.1.0+1）未宣告 AGP namespace，
// 新版 AGP 會建置失敗；在專案評估後補上 namespace。
// 註：必須在下方 evaluationDependsOn(":app") 之前註冊，否則目標專案已被評估。
subprojects {
    afterEvaluate {
        val androidExtension = extensions.findByName("android")
        if (androidExtension is com.android.build.gradle.BaseExtension &&
            androidExtension.namespace == null
        ) {
            androidExtension.namespace = group.toString()
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
