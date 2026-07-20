import com.android.build.api.artifact.SingleArtifact
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.Properties
import java.io.File
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
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// Resolve KEYSTORE_FILE against both plausible bases:
//   - `app/`     — where CI materialises the keystore from GitHub Secrets
//   - `android/` — where it is usually kept locally, beside keystore.properties
// `file(...)` alone would only ever resolve against the module directory, so a
// perfectly valid local setup would fail with "Keystore file not found".
// Absolute paths work unchanged, as `file()` returns them as-is.
val resolvedKeystoreFile: File? =
    (keystoreProperties["KEYSTORE_FILE"] as String?)
        ?.let { path -> listOf(file(path), rootProject.file(path)) }
        ?.firstOrNull { it.exists() }

// Release signing requires BOTH the properties file and the keystore it points
// at. Checking only the former meant a missing/misplaced .jks failed the build
// at `validateSigning...` instead of taking the documented debug-signing
// fallback below.
val hasReleaseSigning = keystorePropertiesFile.exists() && resolvedKeystoreFile != null

if (keystorePropertiesFile.exists() && !hasReleaseSigning) {
    logger.warn(
        "keystore.properties found but KEYSTORE_FILE " +
            "('${keystoreProperties["KEYSTORE_FILE"]}') could not be resolved — " +
            "release builds will fall back to debug signing.",
    )
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

    buildFeatures {
        // Required from AGP 8+: BuildConfig generation is opt-in. We expose a
        // small, non-secret set of fields (see below) so native/plugin code and
        // crash reporting can tell which environment they are running in.
        buildConfig = true
    }

    // -----------------------------------------------------------------------
    // PRODUCT FLAVORS — "which backend / which app identity"
    //
    // A flavor answers exactly one question: *which environment is this?* It
    // controls the application id, the user-visible label and which
    // `google-services.json` is picked up (from src/<flavor>/). It deliberately
    // does NOT decide anything about logging or shrinking — that is the build
    // type's job (see `buildTypes`), which keeps the two axes independent:
    //
    //     flavor    → base URL + app identity + Firebase project
    //     buildType → logging, debug tooling, R8
    //
    // Adding a new environment (qa, staging, uat, ...) is therefore a 3-step,
    // additive change with no edits to existing flavors or build types:
    //   1. add a `create("qa") { ... }` block here,
    //   2. drop `src/qa/google-services.json` in place,
    //   3. add the matching `AppEnvironment` value + `.env_qa` + entry point on
    //      the Dart side (see core/app_env/README of AppConfig).
    //
    // NOTE ON BASE URLs: they are intentionally *not* declared here. The single
    // source of truth for environment values is the Dart config layer
    // (core/app_env, envied-backed) because all networking in this project is
    // Dart/Dio — nothing on the JVM side consumes a URL. Declaring them in both
    // places would create two sources of truth that could silently diverge.
    // -----------------------------------------------------------------------
    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            // Distinct application id so dev and prod can be installed
            // side-by-side on one device. Must match the package name declared
            // in src/dev/google-services.json.
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            manifestPlaceholders["appLabel"] = "Unsaid Dev"
            buildConfigField("String", "ENVIRONMENT", "\"dev\"")
        }

        create("prod") {
            dimension = "environment"
            // No applicationIdSuffix: prod owns the canonical package name
            // `com.user.unsaid`, matching src/prod/google-services.json.
            manifestPlaceholders["appLabel"] = "Unsaid"
            buildConfigField("String", "ENVIRONMENT", "\"prod\"")
        }
    }

    signingConfigs {
        // Only declared when a keystore.properties is available; otherwise the
        // release build type below falls back to the auto-generated debug key.
        if (hasReleaseSigning) {
            create("release") {
                keyAlias = keystoreProperties["KEY_ALIAS"] as String
                keyPassword = keystoreProperties["KEY_PASSWORD"] as String
                // Guaranteed non-null and existing: `hasReleaseSigning` is only
                // true once the file has been resolved.
                storeFile = resolvedKeystoreFile
                storePassword = keystoreProperties["KEYSTORE_PASSWORD"] as String
            }
        }
    }

    // -----------------------------------------------------------------------
    // BUILD TYPES — "how is this built, and how noisy is it?"
    //
    // The build type owns shrinking/obfuscation and the debug-feature switch.
    // Crossed with the two flavors above this yields exactly the four required
    // variants:
    //
    //   devDebug    dev backend   · logging ON  · no shrinking   (local dev)
    //   devRelease  dev backend   · logging OFF · R8 ON          (QA/nightly)
    //   prodDebug   prod backend  · logging ON  · no shrinking   (debug prod)
    //   prodRelease prod backend  · logging OFF · R8 ON          (store build)
    //
    // The Dart side derives the same on/off switch from `kDebugMode`, which maps
    // 1:1 onto these build types — see core/app_env `DebugFeatures`.
    // -----------------------------------------------------------------------
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

            // R8: shrink, optimize and obfuscate. Keep rules live in
            // `proguard-rules.pro`; `proguard-android-optimize.txt` supplies the
            // platform defaults, and the Flutter Gradle plugin contributes the
            // embedding's own rules automatically.
            //
            // R8 only ever sees the JVM half of the app (plugins, Firebase, the
            // Flutter embedding). All Dart code is AOT-compiled into libapp.so
            // and is untouched by shrinking.
            //
            // R8 emits build/.../mapping.txt, which the CI pipeline already
            // uploads as an artifact for crash de-obfuscation.
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )

            // Mirrors the Dart-side `DebugFeatures.disabled()` for any native or
            // plugin code that needs to know. Dart does NOT read this — it uses
            // `kDebugMode`, which is equivalent for these build types.
            buildConfigField("boolean", "DEBUG_FEATURES_ENABLED", "false")
        }

        debug {
            // No applicationIdSuffix here on purpose: the Firebase
            // `google-services.json` files are registered against
            // `com.user.unsaid` / `com.user.unsaid.dev`, and a `.debug` suffix
            // would stop Google Services from resolving the app.
            signingConfig = signingConfigs.getByName("debug")

            isMinifyEnabled = false
            isShrinkResources = false

            buildConfigField("boolean", "DEBUG_FEATURES_ENABLED", "true")
        }
    }
}

// ---------------------------------------------------------------------------
// Human-readable APK copies
//
// Produces, for every variant, an extra APK named:
//
//     unsaid_<yyyy-MM-dd>_<HH-mm-ss>_<version>_<flavor>_<buildType>.apk
//     e.g. unsaid_2026-07-20_16-42-08_1.0.0_dev_release.apk
//
// WHY A COPY AND NOT A RENAME: the Flutter Gradle plugin hardcodes the final
// artifact name (`app[-abi][-flavor]-<mode>.apk`) when it copies APKs into
// `build/app/outputs/flutter-apk/`, and `flutter build apk` fails if that exact
// file is missing. AGP's `outputFileName` cannot override it either, since
// Flutter renames again on the way out. So the canonical file is left untouched
// — which also keeps the CI `Locate APK` glob and `flutter run` working — and
// the friendly name is written next to it.
//
// The copies go to their own `outputs/renamed-apk/` directory. They must NOT be
// written into `outputs/flutter-apk/`: declaring that shared directory as a
// Copy task's output makes Gradle's stale-output cleanup delete every file in
// it that the task did not produce — which silently wipes the canonical
// `app-<flavor>-<mode>.apk` that Flutter and CI depend on.
//
// The timestamp is evaluated at EXECUTION time (inside the rename lambda), not
// at configuration time, so it reflects when the APK was actually built rather
// than when Gradle configured the project.
// ---------------------------------------------------------------------------
androidComponents {
    onVariants { variant ->
        val flavorName = variant.flavorName.orEmpty().ifEmpty { "noflavor" }
        val buildTypeName = variant.buildType.orEmpty().ifEmpty { "nobuildtype" }
        val variantTaskName = variant.name.replaceFirstChar { it.uppercase() }
        val outputDir = layout.buildDirectory.dir("outputs/renamed-apk")

        val renameTask =
            tasks.register<Copy>("renameApk$variantTaskName") {
                description =
                    "Writes a timestamped, human-readable copy of the $variantTaskName APK."
                group = "build"

                // SingleArtifact.APK is a *directory* containing the APK(s) plus
                // an output-metadata.json, hence the include filter. Wiring the
                // provider in also carries the task dependency automatically, so
                // this cannot run before packaging.
                from(variant.artifacts.get(SingleArtifact.APK)) {
                    include("*.apk")
                }
                into(outputDir)

                // Timestamped names never match an existing output, so Gradle
                // would otherwise pile up one APK per build — costly at ~62 MB
                // each. Drop this variant's previous copies first. Uses plain
                // java.io so the task stays configuration-cache compatible.
                doFirst {
                    val dir = outputDir.get().asFile
                    if (dir.isDirectory) {
                        dir.listFiles { file ->
                            file.isFile &&
                                file.name.startsWith("unsaid_") &&
                                file.name.endsWith("_${flavorName}_$buildTypeName.apk")
                        }?.forEach { it.delete() }
                    }
                }

                rename {
                    val stamp =
                        LocalDateTime.now()
                            .format(DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm-ss"))
                    "unsaid_${stamp}_${resolvedVersionName}_${flavorName}_$buildTypeName.apk"
                }
            }

        // `finalizedBy` rather than a `dependsOn`: the copy is a side effect of
        // assembling, and must never be what triggers a build.
        tasks.matching { it.name == "assemble$variantTaskName" }.configureEach {
            finalizedBy(renameTask)
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
    implementation(platform("com.google.firebase:firebase-bom:34.15.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("androidx.multidex:multidex:2.0.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
