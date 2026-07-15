import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Upload keystore credentials cho release signing. File này KHÔNG được commit
// (xem android/.gitignore). Store-candidate tasks must fail closed when it is
// absent or incomplete; they must never inherit debug signing.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
val hasKeystoreProperties = keystorePropertiesFile.exists()
if (hasKeystoreProperties) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}
val releaseSigningKeys = listOf("keyAlias", "keyPassword", "storeFile", "storePassword")
val hasReleaseSigning = hasKeystoreProperties && releaseSigningKeys.all {
    !keystoreProperties.getProperty(it).isNullOrBlank()
}

android {
    namespace = "com.deutschtiger.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.deutschtiger.app"
        // Google Play bắt buộc targetSdk 36 từ 31/08/2026 (plan §9).
        targetSdk = 36
        // minSdk 24 = Android 7.0 (Nougat) — chiếm ~99% thiết bị active.
        minSdk = 24
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    // ProGuard/R8 — Flutter plugin bật sẵn qua `--obfuscate` /
    // `--split-debug-info` khi `flutter build apk --release`. Giữ default ở
    // đây, không ép rule riêng (các plugin Firebase/Supabase cung cấp rules
    // đi kèm).
    buildTypes {
        release {
            // A release signing config is attached only when all required
            // properties are present. Release tasks below fail closed otherwise.
            if (hasReleaseSigning) {
                signingConfig = signingConfigs.getByName("release")
            }
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

tasks.configureEach {
    if (name.equals("assembleRelease", ignoreCase = true) ||
        name.equals("bundleRelease", ignoreCase = true)) {
        doFirst {
            check(hasReleaseSigning) {
                "Release signing is not configured. Supply android/key.properties " +
                    "with keyAlias, keyPassword, storeFile, and storePassword."
            }
            check(rootProject.file(keystoreProperties.getProperty("storeFile")).isFile) {
                "Release keystore file does not exist."
            }
        }
    }
}
