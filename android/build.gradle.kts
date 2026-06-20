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

// 修補部分外掛的 Android 建置設定，相容新版 AGP：
//  1. 未宣告 AGP namespace 者補上（否則建置失敗）。
//  2. 統一 Java / Kotlin 的 JVM target 為 17，避免如 on_audio_query_android
//     其 Java(1.8) 與 Kotlin(toolchain) target 不一致而建置失敗。
//  3. compileSdk 過低者提升至 34，避免如 isar_flutter_libs 因缺少
//     android:attr/lStar(API 31+)而 resource linking 失敗。
// 註：必須在下方 evaluationDependsOn(":app") 之前註冊，否則目標專案已被評估。
subprojects {
    afterEvaluate {
        val androidExtension = extensions.findByName("android")
        if (androidExtension is com.android.build.gradle.BaseExtension) {
            if (androidExtension.namespace == null) {
                androidExtension.namespace = group.toString()
            }
            val currentApi = androidExtension.compileSdkVersion
                ?.removePrefix("android-")?.toIntOrNull() ?: 0
            if (currentApi < 34) {
                androidExtension.compileSdkVersion(34)
            }
            androidExtension.compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
            }
        }
        tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile::class.java)
            .configureEach {
                compilerOptions {
                    jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
                }
            }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
