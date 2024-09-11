package com.example.booksdemo.restApi

import com.example.booksdemo.models.BookConvertible
import com.example.booksdemo.repository.Result
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json
import java.net.HttpURLConnection
import java.net.URL

class RestClient(private val environment: ApiEnvironment) {

    // Define your polymorphic serializers module here
    private val json = Json {
        prettyPrint = true
        ignoreUnknownKeys = true
    }
    private val baseURL: String
        get() = environment.baseUrl

    private suspend fun <T> fetchData(urlString: String, parse: (String) -> T): Result<T> {
        return withContext(Dispatchers.IO) {
            try {
                val url = URL(urlString)
                val connection = url.openConnection() as HttpURLConnection
                connection.requestMethod = "GET"

                val responseCode = connection.responseCode
                if (responseCode !in 200..299) {
                    val errorMessage =
                        connection.errorStream?.bufferedReader()?.use { it.readText() }
                            ?: "Unknown error"
                    return@withContext Result.Failure(
                        APIError.ServerError(
                            responseCode,
                            errorMessage
                        )
                    )
                }

                val data = connection.inputStream.bufferedReader().use { it.readText() }
                val parsedData = parse(data)
                Result.Success(parsedData)
            } catch (e: Exception) {
                Result.Failure(APIError.NetworkError(e))
            }
        }
    }

    suspend fun fetchBooks(): Result<List<BookConvertible>> {
        val url = "${baseURL}/book"
        return fetchData(url) { data ->
            val books = json.decodeFromString<List<ApiBook>>(data)
            books.map { it }
        }
    }

    suspend fun fetchBookById(id: Int): Result<BookConvertible> {
        val url = "${baseURL}/book/$id"
        return fetchData(url) { data ->
            // Deserialize as ApiBook and then cast to BookConvertible
            val apiBook = json.decodeFromString<ApiBook>(data)
            apiBook
        }
    }
}