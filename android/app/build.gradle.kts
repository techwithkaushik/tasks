import java.io.File
import java.util.*
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

val keystoreProperties =
    Properties().apply {
        val file = File("key.properties")
        if (file.exists()) load(file.reader())
    }

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ask9027.tasks"
    compileSdk = flutter.compileSdkVersion
//    ndkVersion = flutter.ndkVersion
    ndkVersion = "27.3.13750724"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://flutter.dev/to/review-gradle-config).
        applicationId = "com.ask9027.tasks"
        // You can update these values to match your application needs.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val storeFilePath = System.getenv("SIGNING_KEY_STORE")
            val storePasswordEnv = System.getenv("SIGNING_STORE_PASSWORD")
            val keyAliasEnv = System.getenv("SIGNING_KEY_ALIAS")
            val keyPasswordEnv = System.getenv("SIGNING_KEY_PASSWORD")

            if (
                !storeFilePath.isNullOrBlank() &&
                !storePasswordEnv.isNullOrBlank() &&
                !keyAliasEnv.isNullOrBlank() &&
                !keyPasswordEnv.isNullOrBlank()
            ) {
                storeFile = file(storeFilePath)
                storePassword = storePasswordEnv
                keyAlias = keyAliasEnv
                keyPassword = keyPasswordEnv
            }
        }
    }

    buildTypes {
        getByName("release") {
            val hasSigning =
                !System.getenv("SIGNING_KEY_STORE").isNullOrBlank() &&
                !System.getenv("SIGNING_STORE_PASSWORD").isNullOrBlank() &&
                !System.getenv("SIGNING_KEY_ALIAS").isNullOrBlank() &&
                !System.getenv("SIGNING_KEY_PASSWORD").isNullOrBlank()

            if (hasSigning) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                // Local release builds may be unsigned, but must never use the debug key.
                println("Release signing is not configured; building an unsigned release APK.")
            }
            isMinifyEnabled = true
            isShrinkResources = true
        }

        getByName("debug") {
            // Keep default debug signing.
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_11)
    }
}

flutter {
    source = "../.."
}
