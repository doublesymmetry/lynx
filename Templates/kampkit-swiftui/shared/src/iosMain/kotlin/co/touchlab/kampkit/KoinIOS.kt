package co.touchlab.kampkit

import co.touchlab.kampkit.concurrency.Immutability
import co.touchlab.kampkit.db.KaMPKitDb
import co.touchlab.kampkit.ktor.DogApiImpl
import co.touchlab.kampkit.ktor.KtorApi
import co.touchlab.kermit.Kermit
import co.touchlab.kermit.NSLogLogger
import com.russhwolf.settings.AppleSettings
import com.russhwolf.settings.Settings
import com.squareup.sqldelight.db.SqlDriver
import com.squareup.sqldelight.drivers.native.NativeSqliteDriver
import kotlinx.cinterop.ObjCClass
import kotlinx.cinterop.getOriginalKotlinClass
import org.koin.core.KoinApplication
import org.koin.core.parameter.parametersOf
import org.koin.core.qualifier.Qualifier
import org.koin.dsl.module
import platform.Foundation.NSBundle
import platform.Foundation.NSDictionary
import platform.Foundation.NSUserDefaults
import platform.Foundation.dictionaryWithContentsOfURL

actual val platformModule = module {
    single<SqlDriver> { NativeSqliteDriver(KaMPKitDb.Schema, "KampkitDb") }

    single<KtorApi> {
        val url = NSBundle.mainBundle().URLForResource("Info", "plist")
        val dict = NSDictionary.dictionaryWithContentsOfURL(url!!)
        val hostURL = dict!!.getValue("HostURL") as String

        DogApiImpl(hostURL, getWith("DogApiImpl"))
    }

    val baseKermit = Kermit(NSLogLogger()).withTag("KampKit")
    factory { (tag: String?) -> if (tag != null) baseKermit.withTag(tag) else baseKermit }
}

object KoinIOS {
    private var koin: KoinApplication? by Immutability(null)

    fun initialize(userDefaults: NSUserDefaults) {
        koin = initKoin(
            module {
                single<Settings> { AppleSettings(userDefaults) }
            }
        )
    }

    fun get(objCClass: ObjCClass, qualifier: Qualifier?, parameter: Any): Any {
        val kClazz = getOriginalKotlinClass(objCClass)!!
        return koin!!.koin.get(kClazz, qualifier) { parametersOf(parameter) }
    }

    fun get(objCClass: ObjCClass, parameter: Any): Any {
        val kClazz = getOriginalKotlinClass(objCClass)!!
        return koin!!.koin.get(kClazz, null) { parametersOf(parameter) }
    }

    fun get(objCClass: ObjCClass, qualifier: Qualifier?): Any {
        val kClazz = getOriginalKotlinClass(objCClass)!!
        return koin!!.koin.get(kClazz, qualifier, null)
    }
}
