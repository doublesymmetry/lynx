package com.doublesymmetry.lynx.features

import com.doublesymmetry.lynx.Api
import co.touchlab.kermit.Kermit
import dev.icerock.moko.mvvm.livedata.MutableLiveData
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import org.koin.core.KoinComponent
import org.koin.core.inject
import org.koin.core.parameter.parametersOf

class MainViewModel: KoinComponent {
    private val api: Api by inject()
    private val log: Kermit by inject { parametersOf(this::class.simpleName) }

    var fact: MutableLiveData<String> = MutableLiveData("")

    fun fetchFact() {
        log.i { "Fetching random fact..." }

        GlobalScope.launch(Dispatchers.Main) {
            val result = api.fetchRandomFact()
            fact.value = result
        }
    }
}