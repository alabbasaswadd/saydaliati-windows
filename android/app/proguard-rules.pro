# Flutter engine + plugin registrant (reflection at startup).
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Keep annotations / generics / enclosing info used by various plugins.
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod, Exceptions

# Kotlin metadata.
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.**

# sqlite3 (drift native bindings).
-keep class org.sqlite.** { *; }
-dontwarn org.sqlite.**

# Play Core (referenced by Flutter's deferred-components stubs; not used here).
-dontwarn com.google.android.play.core.**
