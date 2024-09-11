package com.example.booksdemo.preview

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.flowOf
import com.example.booksdemo.intent.BookIntent
import com.example.booksdemo.intent.BookIntentHandlerInterface
import com.example.booksdemo.intent.BookState
import com.example.booksdemo.models.Book
import com.example.booksdemo.repository.BookRepositoryInterface
import kotlinx.coroutines.flow.Flow

import com.example.booksdemo.repository.Result
import com.example.booksdemo.service.ConnectionStatusServiceInterface


// Mock data for the preview
val mockBooks = listOf(
    Book(id = 1, title = "Mocked Book 1", author = "Mock Author 1", description = "Mock description of the book 1.", coverImageUrl = "https://loremflickr.com/640/480/abstract"),
    Book(id = 2, title = "Mocked Book 2", author = "Mock Author 2", description = "Mock description of the book 2.", coverImageUrl = "https://loremflickr.com/640/480/abstract"),
    Book(id = 3, title = "Mocked Book 3", author = "Mock Author 3", description = "Mock description of the book 3.", coverImageUrl = "https://loremflickr.com/640/480/abstract")
)

// Mock implementation of BookRepositoryInterface
class MockBookRepository : BookRepositoryInterface {
    override suspend fun fetchBooks(): Result<List<Book>> {
        return Result.Success(mockBooks)
    }

    override suspend fun fetchFavorites(): Result<List<Int>> {
        return Result.Success(listOf(1, 2)) // Mock favorite book IDs
    }

    override suspend fun search(query: String, isFavorite: Boolean): Result<List<Book>> {
        val filteredBooks = mockBooks.filter { it.title.contains(query, ignoreCase = true) }
        return Result.Success(filteredBooks)
    }

    override suspend fun favoriteMark(id: Int, isFavorite: Boolean): Result<Unit> {
        // Assume success for mock
        return Result.Success(Unit)
    }

    override suspend fun syncBooks(): Result<Unit> {
        // Assume success for mock
        return Result.Success(Unit)
    }
}

// Mock implementation of ConnectionStatusServiceInterface
class MockConnectionStatusService : ConnectionStatusServiceInterface {
    override fun observeConnectionStatus(): Flow<Boolean> {
        // Assume the connection is always available for preview purposes
        return flowOf(true)
    }

    override suspend fun isConnected(): Boolean {
        // Assume connected in preview
        return true
    }
}

// Mock BookIntentHandler using the mock repository and connection service
val mockIntentHandler = object : BookIntentHandlerInterface {
    private val _mockState = MutableStateFlow(
        BookState(
            books = mockBooks ,
            favorites = mockBooks.map { it.id },
            searchResults = mockBooks,
            isLoading = false,
            error = null
        )
    )
    override val state: StateFlow<BookState> get() = _mockState

    override suspend fun handle(intent: BookIntent) {
        // Mock behavior for handling intents
    }
}
