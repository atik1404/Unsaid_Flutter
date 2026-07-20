# ===========================================================================
# R8 / ProGuard rules
#
# Applied to the `release` build type of BOTH flavors (devRelease, prodRelease)
# via `proguardFiles(...)` in build.gradle.kts, on top of the platform defaults
# from `proguard-android-optimize.txt`.
#
# SCOPE: R8 only processes the JVM half of this app — the Flutter embedding,
# Gradle-level dependencies and the Android side of Flutter plugins. All Dart
# code is AOT-compiled into `libapp.so` and is never shrunk or obfuscated here,
# so Dio/JSON serialization on the Dart side needs no rules.
#
# The risk surface is therefore anything the JVM reaches REFLECTIVELY, since R8
# cannot see those references statically: Gson-backed plugin models, Firebase
# service discovery, and Play Core.
# ===========================================================================

# ---------------------------------------------------------------------------
# Crash reporting / stack traces
#
# `proguard-android-optimize.txt` strips these attributes. Crashlytics needs
# them (together with the uploaded mapping.txt) to reproduce readable stack
# traces. `-renamesourcefileattribute` then replaces the real file name with the
# literal "SourceFile" so nothing about the source layout leaks.
# ---------------------------------------------------------------------------
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Generic signatures + annotations: required by every reflection-based
# serializer below. Stripping these is the classic cause of "field is always
# null after enabling R8".
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes InnerClasses,EnclosingMethod
# Needed by anything using @Keep and by AndroidX lifecycle/annotation tooling.
-keepattributes RuntimeVisibleAnnotations,RuntimeVisibleParameterAnnotations

# Anything explicitly annotated @Keep must survive.
-keep class androidx.annotation.Keep
-keep @androidx.annotation.Keep class * { *; }
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# ---------------------------------------------------------------------------
# Flutter embedding
#
# The Flutter Gradle plugin contributes its own rules, but the embedding and
# generated plugin registrant are instantiated reflectively by name, so we keep
# them explicitly rather than relying on that.
# ---------------------------------------------------------------------------
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# JNI entry points: native method names must never be renamed.
-keepclasseswithmembernames class * {
    native <methods>;
}

# ---------------------------------------------------------------------------
# Android platform contracts that rely on reflection
# ---------------------------------------------------------------------------
# Enum valueOf/values() are called reflectively by the platform and by Gson.
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Parcelable CREATOR fields are looked up by name.
-keepclassmembers class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

# Serializable's private hooks are invoked reflectively.
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Views inflated from XML need their (Context, AttributeSet) constructors.
-keepclasseswithmembers class * extends android.view.View {
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

# ---------------------------------------------------------------------------
# Gson
#
# Reaches this app through flutter_local_notifications (com.dexterous), which
# serializes its scheduled-notification models with Gson. Without these, R8
# nulls out fields and scheduled notifications silently break.
# ---------------------------------------------------------------------------
-dontwarn sun.misc.**

-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Prevent R8 from leaving @SerializedName-annotated members always null.
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Retain generic signatures of TypeToken and its subclasses (R8 3.0+).
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken

# flutter_local_notifications' Gson-serialized model classes.
-keep class com.dexterous.** { *; }

# ---------------------------------------------------------------------------
# Firebase (core, analytics, messaging, crashlytics, auth)
#
# Firebase discovers components via reflection over generated registrar classes
# and annotated constructors.
# ---------------------------------------------------------------------------
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Crashlytics needs its own model classes intact to serialize reports.
-keep class com.google.firebase.crashlytics.** { *; }
-dontwarn com.google.firebase.crashlytics.**

# Firebase component registration is annotation-driven.
-keepclassmembers class * {
    @com.google.firebase.components.ComponentRegistrar *;
}
-keep class * implements com.google.firebase.components.ComponentRegistrar { *; }

# ---------------------------------------------------------------------------
# Google Play Core / Play In-App Update  (in_app_update plugin)
#
# Flutter's embedding also references Play Core for deferred components. When
# Play Core is absent or partially present, R8 reports missing classes and
# fails the build — these keep/dontwarn pairs are the standard remedy.
# ---------------------------------------------------------------------------
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# ---------------------------------------------------------------------------
# WebView  (webview_flutter, flutter_inappwebview, flutter_widget_from_html)
#
# Any @JavascriptInterface member is called by name from JS and must not be
# renamed or removed.
# ---------------------------------------------------------------------------
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keep class * extends android.webkit.WebChromeClient { *; }
-dontwarn android.webkit.**

# ---------------------------------------------------------------------------
# Microsoft Clarity  (clarity_flutter)
#
# Instruments the view hierarchy reflectively.
# ---------------------------------------------------------------------------
-keep class com.microsoft.clarity.** { *; }
-dontwarn com.microsoft.clarity.**

# ---------------------------------------------------------------------------
# Misc plugins with reflective or optional dependencies
# ---------------------------------------------------------------------------
# flutter_secure_storage — AndroidX Security / Tink key handling.
-keep class androidx.security.crypto.** { *; }
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.crypto.tink.**

# background_downloader — WorkManager workers are instantiated by class name.
-keep class * extends androidx.work.Worker
-keep class * extends androidx.work.ListenableWorker {
    public <init>(...);
}

# Kotlin coroutines internals referenced reflectively by several plugins.
-dontwarn kotlinx.coroutines.**
-keepclassmembers class kotlinx.coroutines.** {
    volatile <fields>;
}

# Conscrypt / OkHttp platform probing (pulled in transitively by Firebase).
# These are optional at runtime; suppress the missing-class warnings only.
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**

# ---------------------------------------------------------------------------
# This app's own native entry point
# ---------------------------------------------------------------------------
-keep class com.user.unsaid.** { *; }
