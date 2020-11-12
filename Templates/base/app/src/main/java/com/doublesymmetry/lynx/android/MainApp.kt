package com.doublesymmetry.lynx.android

import android.app.Application
import android.content.Context
import android.content.SharedPreferences
import com.doublesymmetry.lynx.AppInfo
import com.doublesymmetry.lynx.initKoin
import org.koin.dsl.module

class MainApp : Application() {
    override fun onCreate() {
        super.onCreate()
        initKoin(
            module {
                single<Context> { this@MainApp }
                single<SharedPreferences> {
                    get<Context>().getSharedPreferences("LYNX_SETTINGS", Context.MODE_PRIVATE)
                }
                single<AppInfo> { AndroidAppInfo }
            }
        )
    }
}

object AndroidAppInfo : AppInfo {
    override val appId: String = BuildConfig.APPLICATION_ID
    override val hostUrl: String = BuildConfig.HOST_URL
}
