package co.touchlab.kampkit

import co.touchlab.kampkit.db.KaMPKitDb
import co.touchlab.kampkit.ktor.DogApiImpl
import co.touchlab.kampkit.ktor.KtorApi
import co.touchlab.kermit.Kermit
import co.touchlab.kermit.LogcatLogger
import com.russhwolf.settings.AndroidSettings
import com.russhwolf.settings.Settings
import com.squareup.sqldelight.android.AndroidSqliteDriver
import com.squareup.sqldelight.db.SqlDriver
import org.koin.core.module.Module
import org.koin.core.qualifier.qualifier
import org.koin.dsl.module

actual val platformModule: Module = module {
    single<SqlDriver> {
        AndroidSqliteDriver(
            KaMPKitDb.Schema,
            get(),
            "KampkitDb"
        )
    }

    single<Settings> {
        AndroidSettings(get())
    }

    single<KtorApi> {
        DogApiImpl(get(qualifier = qualifier("HostURL")), getWith("DogApiImpl"))
    }

    val baseKermit = Kermit(LogcatLogger()).withTag("KampKit")
    factory { (tag: String?) -> if (tag != null) baseKermit.withTag(tag) else baseKermit }
}
