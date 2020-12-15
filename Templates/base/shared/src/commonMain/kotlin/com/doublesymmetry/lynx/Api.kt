package com.doublesymmetry.lynx

import co.touchlab.kermit.Kermit
import co.touchlab.stately.ensureNeverFrozen
import io.ktor.client.HttpClient
import io.ktor.client.features.json.JsonFeature
import io.ktor.client.features.json.serializer.KotlinxSerializer
import io.ktor.client.features.logging.LogLevel
import io.ktor.client.features.logging.Logger
import io.ktor.client.features.logging.Logging
import io.ktor.client.request.HttpRequestBuilder
import io.ktor.client.request.get
import io.ktor.client.request.header
import io.ktor.client.request.headers
import io.ktor.http.ContentType
import io.ktor.http.contentType
import io.ktor.http.takeFrom
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

class Api(private val appInfo: AppInfo, private val log: Kermit) {
    private val json: Json = Json {
        ignoreUnknownKeys = true
        allowSpecialFloatingPointValues = true
        isLenient = true
    }

    private val client = HttpClient {
        install(JsonFeature) {
            serializer = KotlinxSerializer(json)
        }
        install(Logging) {
            logger = object : Logger {
                override fun log(message: String) {
                    log.v("Network") { message }
                }
            }

            level = LogLevel.INFO
        }
    }

    init {
        ensureNeverFrozen()
    }

    private val baseBuilder
        get() = HttpRequestBuilder().apply {
            url { takeFrom(appInfo.hostUrl) }
            headers {
                header("Content-Type", "application/json")
            }

            contentType(ContentType.Application.Json)
        }

    suspend fun fetchRandomFact(): String {
        val builder = baseBuilder.apply {
            url.apply {
                encodedPath = encodedPath.let { startingPath ->
                    path("facts")
                    return@let startingPath + encodedPath.substring(1)
                }
            }
        }

        return client.get<Response>(builder).shuffled().take(1)[0].text
    }
}

typealias Response = List<Fact>

@Serializable
data class Fact(
    val text: String
)