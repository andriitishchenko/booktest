package com.example.booksdemo.repository
import android.content.Context
import com.example.booksdemo.db.BookDatabase
import com.example.booksdemo.intent.BookIntentHandler
import com.example.booksdemo.restApi.ApiEnvironment
import com.example.booksdemo.restApi.RestClient
import com.example.booksdemo.service.ConnectionStatusService
import com.example.booksdemo.source.LocalStorageSourceImpl
import com.example.booksdemo.source.RemoteSourceImpl

class DefaultRepositoryFactory(
    private val context: Context,
    private val apiEnvironment: ApiEnvironment
) : RepositoryFactory {

    override fun createBookRepository(): BookRepository {
        val bookDao = BookDatabase.getDatabase(context).bookDao()
        val localStorageSource = LocalStorageSourceImpl(bookDao)
        val restClient = RestClient(environment = apiEnvironment)
        val remoteSource = RemoteSourceImpl(restClient)
        return BookRepository( localStorage = localStorageSource,
            remoteSource = remoteSource)
    }

    override fun createBookIntentHandler(): BookIntentHandler {
        val bookRepository = createBookRepository()

        val connectionService = ConnectionStatusService(context)
        return BookIntentHandler(repository = bookRepository, connectionService = connectionService)

    }
}