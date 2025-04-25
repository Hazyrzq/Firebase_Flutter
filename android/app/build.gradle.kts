plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")  // Tambahkan plugin Google Services
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.project_firebase_realtime"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
    applicationId = "com.example.projectfirebase"  // Ubah ini sesuai google-services.json
    minSdk = flutter.minSdkVersion
    targetSdk = flutter.targetSdkVersion
    versionCode = flutter.versionCode
    versionName = flutter.versionName
}

    buildTypes {
        release {
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Tambahkan platform Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:32.7.2"))
    
    // Tambahkan dependensi Firebase yang diperlukan
    implementation("com.google.firebase:firebase-database")
    implementation("com.google.firebase:firebase-analytics")
}