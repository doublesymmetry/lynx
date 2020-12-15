import org.jetbrains.kotlin.gradle.plugin.mpp.KotlinNativeTarget

plugins {
    kotlin("multiplatform")
    id("co.touchlab.native.cocoapods")
    id("kotlinx-serialization")
    id("com.android.library")
}

android {
    compileSdkVersion(Versions.compile_sdk)
    defaultConfig {
        minSdkVersion(Versions.min_sdk)
        targetSdkVersion(Versions.target_sdk)
        versionCode = 1
        versionName = "1.0"
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    lintOptions {
        isWarningsAsErrors = true
        isAbortOnError = true
    }
}

kotlin {
    android()
    val iOSTarget: (String) -> KotlinNativeTarget =
        if (System.getenv("SDK_NAME")?.startsWith("iphoneos") == true)
            ::iosArm64
        else
            ::iosX64

    iOSTarget("ios")

    version = "1.1"

    sourceSets {
        all {
            languageSettings.apply {
                useExperimentalAnnotation("kotlin.RequiresOptIn")
                useExperimentalAnnotation("kotlinx.coroutines.ExperimentalCoroutinesApi")
            }
        }

        val commonMain by getting {
            dependencies {
                implementation(Deps.Ktor.commonCore)
                implementation(Deps.Ktor.commonJson)
                implementation(Deps.Ktor.commonLogging)
                implementation(Deps.Coroutines.common) {
                    version {
                        strictly(Versions.coroutines)
                    }
                }
                implementation(Deps.stately)
                implementation(Deps.multiplatformSettings)
                implementation(Deps.koinCore)
                implementation(Deps.Ktor.commonSerialization)
                api(Deps.kermit)
                api(Deps.mokoMvvm)
            }
        }

        val commonTest by getting {
            dependencies {
                implementation(Deps.multiplatformSettingsTest)
                implementation(Deps.KotlinTest.common)
                implementation(Deps.KotlinTest.annotations)
                implementation(Deps.koinTest)
                // Karmok is an experimental library which helps with mocking interfaces
                implementation(Deps.karmok)
            }
        }

        val androidMain by getting {
            dependencies {
                implementation(kotlin("stdlib", Versions.kotlin))
                implementation(Deps.Coroutines.android) {
                    version {
                        strictly(Versions.coroutines)
                    }
                }
                implementation(Deps.Ktor.androidCore)
            }
        }

        val androidTest by getting {
            dependencies {
                implementation(Deps.KotlinTest.jvm)
                implementation(Deps.KotlinTest.junit)
                implementation(Deps.AndroidXTest.core)
                implementation(Deps.AndroidXTest.junit)
                implementation(Deps.AndroidXTest.runner)
                implementation(Deps.AndroidXTest.rules)
                implementation(Deps.Coroutines.test)
                implementation(Deps.robolectric)
            }
        }

        val iosMain by getting {
            dependencies {
                implementation(Deps.Ktor.ios)
                implementation(Deps.Coroutines.common)
                implementation(Deps.koinCore)
            }
        }
    }

    cocoapodsext {
        summary = "Shared library for Lynx generated app"
        homepage = "https://github.com/doublesymmetry/lynx"
        framework {
            isStatic = false
            export(Deps.kermit)
            transitiveExport = true
        }
    }
}
