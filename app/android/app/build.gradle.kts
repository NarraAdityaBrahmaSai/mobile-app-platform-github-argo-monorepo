plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.mobileplatform.app"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.mobileplatform.app"
        minSdk = 26
        targetSdk = 36
        versionCode = providers.environmentVariable("ANDROID_VERSION_CODE")
            .orElse("1")
            .get()
            .toInt()
        versionName = providers.environmentVariable("ANDROID_VERSION_NAME")
            .orElse("1.0.0")
            .get()

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    signingConfigs {
        create("release") {
            val keystoreFile = providers.environmentVariable("ANDROID_KEYSTORE_FILE")
            if (keystoreFile.isPresent) {
                storeFile = file(keystoreFile.get())
                storePassword = providers.environmentVariable("ANDROID_KEYSTORE_PASSWORD").orElse("").get()
                keyAlias = providers.environmentVariable("ANDROID_KEY_ALIAS").orElse("").get()
                keyPassword = providers.environmentVariable("ANDROID_KEY_PASSWORD").orElse("").get()
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }

        debug {
            applicationIdSuffix = ".debug"
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.17.0")
    implementation("androidx.activity:activity-ktx:1.11.0")
    implementation("androidx.appcompat:appcompat:1.8.0")
    testImplementation("junit:junit:4.13.2")
}
