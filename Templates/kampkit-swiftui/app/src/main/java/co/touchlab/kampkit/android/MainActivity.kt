package co.touchlab.kampkit.android

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import co.touchlab.kampkit.android.adapter.MainAdapter
import co.touchlab.kampkit.models.BreedViewModel
import co.touchlab.kampkit.models.BreedViewModelDelegate
import co.touchlab.kampkit.models.ItemDataSummary
import co.touchlab.kermit.Kermit
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.activity_main.*
import org.koin.core.KoinComponent
import org.koin.core.inject
import org.koin.core.parameter.parametersOf

class MainActivity : AppCompatActivity(), KoinComponent {
    companion object {
        val TAG = MainActivity::class.java.simpleName
    }
    private lateinit var adapter: MainAdapter
    private val log: Kermit by inject { parametersOf("MainActivity") }

    private val viewModel: BreedViewModel = BreedViewModel(object: BreedViewModelDelegate {
        override fun onSummaryUpdate(summary: ItemDataSummary) {
            log.v { "List submitted to adapter" }
            adapter.submitList(summary.allItems)
        }

        override fun onErrorUpdate(error: String) {
            log.e { "Error displayed: $error" }
            Snackbar.make(breed_list, error, Snackbar.LENGTH_SHORT).show()
        }
    })

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        adapter = MainAdapter {
            viewModel.updateBreedFavorite(it)
        }

        breed_list.adapter = adapter
        breed_list.layoutManager = LinearLayoutManager(this)

        viewModel.fetchBreeds()
    }
}
