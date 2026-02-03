# OkHttp platform rules
-dontwarn org.bouncycastle.jsse.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**

# Ktor
-dontwarn java.lang.management.**

# SLF4J
-dontwarn org.slf4j.impl.StaticLoggerBinder

# Keep OkHttp
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

# Keep Ktor
-keep class io.ktor.** { *; }
-dontwarn io.ktor.**