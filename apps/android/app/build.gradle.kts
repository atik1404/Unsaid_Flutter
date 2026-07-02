import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("keystore.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

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
        versionCode = 1
        versionName = "1.0.0"
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
