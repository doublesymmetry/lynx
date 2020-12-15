package com.doublesymmetry.lynx.android

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.doublesymmetry.lynx.features.MainViewModel
import co.touchlab.kermit.Kermit
import com.doublesymmetry.lynx.android.databinding.ActivityMainBinding
import org.koin.core.KoinComponent
import org.koin.core.inject
import org.koin.core.parameter.parametersOf

class MainActivity: AppCompatActivity(), KoinComponent {
    private val log: Kermit by inject { parametersOf(TAG) }
    private val binding by lazy { ActivityMainBinding.inflate(layoutInflater) }

    private val viewModel = MainViewModel()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        log.d { "onCreate" }
        setContentView(binding.root)

        viewModel.fact.ld().observe(this, { fact ->
            binding.textView.text = fact
        })

        viewModel.fetchFact()
    }

    companion object {
        val TAG = MainActivity::class.java.simpleName
    }
}
