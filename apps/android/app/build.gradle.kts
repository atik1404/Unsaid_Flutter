import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    id("dev.flutter.flutter-gradle-plugin")
}

// ---------------------------------------------------------------------------
// Release signing configuration.
//
// Signing credentials are NEVER hard-coded. They are supplied through a
// `keystore.properties` file placed next to this module's root
// (apps/android/keystore.properties). Locally you create it by hand; in CI it
// is generated on the fly from GitHub Secrets (see CI_CD_SETUP.md).
//
// When the file is absent (e.g. a fresh clone or a PR build without secrets)
// the release build type transparently falls back to debug signing so that
// local development and unsigned CI builds keep working unchanged.
// ---------------------------------------------------------------------------
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("keystore.properties")
val hasReleaseSigning = keystorePropertiesFile.exists()
if (hasReleaseSigning) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// Flutter injects version information into `local.properties` via
// `--build-name` / `--build-number`. Read it here so CI can stamp a unique
// version code (workflow run number) onto every build instead of the value
// being pinned to a hard-coded constant.
val flutterProperties = Properties()
val flutterPropertiesFile = rootProject.file("local.properties")
if (flutterPropertiesFile.exists()) {
    flutterPropertiesFile.inputStream().use { flutterProperties.load(it) }
}
val resolvedVersionCode =
    (project.findProperty("versionCode") as String?
        ?: flutterProperties.getProperty("flutter.versionCode"))
        ?.toIntOrNull() ?: 1
val resolvedVersionName =
    (project.findProperty("versionName") as String?
        ?: flutterProperties.getProperty("flutter.versionName"))
        ?: "1.0.0"

android {
    namespace = "com.user.unsaid"
    compileSdk = 36
    ndkVersion = "29.0.14206865"

    externalNativeBuild {
        cmake {
            version = "4.1.2"
        }
    }

    defaultConfig {
        applicationId = "com.user.unsaid"
         minSdk =  24
        targetSdk = 36
        // Version is resolved from Flutter's local.properties (or a `-PversionCode`
        // / `-PversionName` Gradle property override) so CI can inject a unique,
        // monotonically increasing version code per build.
        versionCode = resolvedVersionCode
        versionName = resolvedVersionName
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
        }

        create("prod") {
            
        }
    }

    signingConfigs {
        // Only declared when a keystore.properties is available; otherwise the
        // release build type below falls back to the auto-generated debug key.
        if (hasReleaseSigning) {
            create("release") {
                keyAlias = keystoreProperties["KEY_ALIAS"] as String
                keyPassword = keystoreProperties["KEY_PASSWORD"] as String
                storeFile = (keystoreProperties["KEYSTORE_FILE"] as String?)?.let { file(it) }
                storePassword = keystoreProperties["KEYSTORE_PASSWORD"] as String
            }
        }
    }

    buildTypes {
        release {
            // Sign with the real upload key when credentials are present, else
            // fall back to debug signing so unsigned/PR builds still produce an
            // installable APK without leaking or requiring secrets.
            signingConfig =
                if (hasReleaseSigning) {
                    signingConfigs.getByName("release")
                } else {
                    signingConfigs.getByName("debug")
                }

            // R8/code shrinking is intentionally left OFF by default to avoid
            // introducing runtime breakage. `proguard-rules.pro` is already in
            // place; flip these two flags to `true` once the rules are verified
            // end-to-end. When enabled, R8 emits build/.../mapping.txt which the
            // CI pipeline already uploads as an artifact for crash de-obfuscation.
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
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
    implementation(platform("com.google.firebase:firebase-bom:34.16.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("androidx.multidex:multidex:2.0.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
