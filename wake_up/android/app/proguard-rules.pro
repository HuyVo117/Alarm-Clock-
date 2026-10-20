# Proguard rules to prevent R8 from stripping Pigeon / reflection methods

# SharedPreferences (prevents NoSuchMethodError on SharedPreferencesApiRegistrar.getAll)
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep interface io.flutter.plugins.sharedpreferences.** { *; }

# Alarm package
-keep class com.gdelataillade.alarm.** { *; }

# Just Audio
-keep class com.ryanheise.just_audio.** { *; }

# General Flutter plugins platform channels
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
