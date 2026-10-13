import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing — loaded from android/key.properties (kept OUT of git). When the
// file (and keystore) are present the release build is signed with the stable
// Saydaliati key so updates install over previous versions; otherwise it falls
// back to the debug key so `flutter run --release` still works on dev machines.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasReleaseKeystore =
    keystorePropertiesFile.exists() &&
        file((Properties().apply { load(FileInputStream(keystorePropertiesFile)) })["storeFile"] as String).exists()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// Dev signing — a SEPARATE key (android/dev.key.properties) so the dev build has
// a different signature AND a different applicationId (.dev), letting it install
// side-by-side with the production app.
val devKeystoreProperties = Properties()
val devKeystorePropertiesFile = rootProject.file("dev.key.properties")
val hasDevKeystore =
    devKeystorePropertiesFile.exists() &&
        file((Properties().apply { load(FileInputStream(devKeystorePropertiesFile)) })["storeFile"] as String).exists()
if (devKeystorePropertiesFile.exists()) {
    devKeystoreProperties.load(FileInputStream(devKeystorePropertiesFile))
}

android {
    namespace = "com.saydaliati.saydaliati"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.saydaliati.saydaliati"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // mobile_scanner (camera) and flutter_secure_storage need API 21+/23+;
        // floor the Flutter default so those plugins build/run everywhere.
        minSdk = maxOf(flutter.minSdkVersion, 23)
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Default app label; the dev flavor overrides it to "صيدليتي ديف".
        manifestPlaceholders["appLabel"] = "صيدليتي"
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                // Sign with BOTH the legacy JAR (v1) and v2 schemes so the package
                // installs on every device (some OEMs/older builds reject v2-only).
                enableV1Signing = true
                enableV2Signing = true
            }
        }
        if (hasDevKeystore) {
            create("dev") {
                keyAlias = devKeystoreProperties["keyAlias"] as String
                keyPassword = devKeystoreProperties["keyPassword"] as String
                storeFile = file(devKeystoreProperties["storeFile"] as String)
                storePassword = devKeystoreProperties["storePassword"] as String
                // v1 (JAR) + v2 → avoids the "الحزمة غير صالحة" install error that a
                // v2-only signature triggers on some devices.
                enableV1Signing = true
                enableV2Signing = true
            }
        }
    }

    // Two environments as product flavors so the dev build is a distinct app
    // (own id, name, and signing key) that coexists with production.
    flavorDimensions += "env"
    productFlavors {
        create("prod") {
            dimension = "env"
            // applicationId = com.saydaliati.saydaliati (no suffix), label صيدليتي
            signingConfig = if (hasReleaseKeystore)
                signingConfigs.getByName("release")
            else
                signingConfigs.getByName("debug")
        }
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            manifestPlaceholders["appLabel"] = "صيدليتي ديف"
            signingConfig = if (hasDevKeystore)
                signingConfigs.getByName("dev")
            else
                signingConfigs.getByName("debug")
        }
    }

    buildTypes {
        release {
            // Signing is decided per-flavor (prod → release key, dev → dev key).
            // Shrink the download: R8 code shrinking + unused-resource removal.
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
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
