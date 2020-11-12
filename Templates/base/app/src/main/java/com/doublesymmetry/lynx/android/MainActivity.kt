package com.doublesymmetry.lynx.android

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.doublesymmetry.lynx.features.MainViewModel
import co.touchlab.kermit.Kermit
import org.koin.core.KoinComponent
import org.koin.core.inject
import org.koin.core.parameter.parametersOf

class MainActivity: AppCompatActivity(), KoinComponent {
    private val log: Kermit by inject { parametersOf(TAG) }

    private val viewModel = MainViewModel()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        log.d { "onCreate" }
        setContentView(R.layout.activity_main)

        val tv: TextView = findViewById(R.id.text_view)

        viewModel.fact.ld().observe(this, { fact ->
            tv.text = fact
        })

        viewModel.fetchFact()
    }

    companion object {
        val TAG = MainActivity::class.java.simpleName
    }
}
