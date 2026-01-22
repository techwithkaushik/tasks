import java.io.File
import java.util.*

val keystoreProperties =
    Properties().apply {
        var file = File("key.properties")
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

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ask9027.tasks"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Read secrets from environment (set in GitHub Actions)
            val storeFilePath   = System.getenv("SIGNING_KEY_STORE")
            val storePasswordEnv = System.getenv("SIGNING_STORE_PASSWORD")
            val keyAliasEnv      = System.getenv("SIGNING_KEY_ALIAS")
            val keyPasswordEnv   = System.getenv("SIGNING_KEY_PASSWORD")

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
            } else {
                // Optional: log a warning for local builds without signing
                println("⚠️ Release signing is NOT configured (missing env vars).")
            }
        }
    }

    buildTypes {
        getByName("release") {
            // Only use release signing if env vars exist
            val hasSigning = !System.getenv("SIGNING_KEY_STORE").isNullOrBlank()
            if (hasSigning) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                // Fallback: use debug signing so `./gradlew assembleRelease` still works
                signingConfig = signingConfigs.getByName("debug")
            }
            // your other release options...
            isMinifyEnabled = true
            isShrinkResources = true
        }

        getByName("debug") {
            // Keep default debug signing (no change needed)
        }
    }
}

flutter {
    source = "../.."
}
