import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("keystore.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.playground.flutter_multi_package_playground"
    compileSdk = 36
    ndkVersion = "29.0.14206865"

    externalNativeBuild {
        cmake {
            version = "4.1.2"
        }
    }

    defaultConfig {
        applicationId = "com.playground.flutter_multi_package_playground"
         minSdk =  24
        targetSdk = 36
        versionCode = 1
        versionName = "1.0.0"
    }

     compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            resValue(
                type = "string",
                name = "app_name",
                value = "Dev Unsaid"
            )
        }

        create("prod") {
            dimension = "environment"
            resValue(
                type = "string",
                name = "app_name",
                value = "Unsaid"
            )
        }
    }

    // signingConfigs{
    //     create("release") {
    //         keyAlias = keystoreProperties["KEY_ALIAS"] as String
    //         keyPassword = keystoreProperties["KEY_PASSWORD"] as String
    //         storeFile = keystoreProperties["KEYSTORE_FILE"]?.let { file(it) }
    //         storePassword = keystoreProperties["KEYSTORE_PASSWORD"] as String
    //     }
    // }

    buildTypes {
        // release {
        //     isMinifyEnabled = true
        //     isShrinkResources = true
        //     signingConfig = signingConfigs.getByName("release")
        //     proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        // }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    //implementation(platform("com.google.firebase:firebase-bom:34.3.0"))
    //implementation("com.google.firebase:firebase-analytics")
    implementation("androidx.multidex:multidex:2.0.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
