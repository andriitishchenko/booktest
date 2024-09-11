package com.example.booksdemo.intent

import com.example.booksdemo.repository.BookRepositoryInterface
import com.example.booksdemo.repository.Result
import com.example.booksdemo.service.ConnectionStatusServiceInterface
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch


class BookIntentHandler(
    private val repository: BookRepositoryInterface,
    private val connectionService: ConnectionStatusServiceInterface
):BookIntentHandlerInterface {
    private val _state = MutableStateFlow(BookState())
    override val state: StateFlow<BookState> get() = _state

    init {
        observeConnectionStatus()
    }
    private fun observeConnectionStatus() {
        CoroutineScope(Dispatchers.IO).launch {
            connectionService.observeConnectionStatus().collectLatest { isConnected ->
                _state.value = _state.value.copy(
                    isLoading = false,
                    error = if (!isConnected) "No internet connection" else null
                )
                if (isConnected){
                    syncBooks()
                }
            }
        }
    }

    override suspend fun handle(intent: BookIntent) {
        when (intent) {
            is BookIntent.LoadBooks -> loadBooks()
            is BookIntent.LoadFavorites -> loadFavorites()
            is BookIntent.SearchBooks -> searchBooks(intent.query)
            is BookIntent.FilterBooks -> filterBooks(intent.query)
            is BookIntent.ToggleFavorite -> toggleFavorite(intent.id, intent.isFavorite)
            is BookIntent.NavigateTo -> navigateTo(intent.screen)
            is BookIntent.SyncBooks -> syncBooks()
            is BookIntent.HideError -> hideError()
            else -> {}
        }
    }

    private suspend fun loadBooks() {
        _state.value = _state.value.copy(isLoading = true)
        when (val result = repository.fetchBooks()) {
            is Result.Success -> {
                _state.value = _state.value.copy(
                    books = result.data,
                    isLoading = false,
                    error = null
                )
            }
            is Result.Failure -> {
                _state.value = _state.value.copy(
                    isLoading = false,
                    error = result.exception.message
                )
            }
        }
    }

    private suspend fun loadFavorites() {
        _state.value = _state.value.copy(isLoading = true)
        when (val result = repository.fetchFavorites()) {
            is Result.Success -> {
                _state.value = _state.value.copy(
                    favorites = result.data,
                    isLoading = false,
                    error = null
                )
            }
            is Result.Failure -> {
                _state.value = _state.value.copy(
                    isLoading = false,
                    error = result.exception.message
                )
            }
        }
    }

    private suspend fun searchBooks(query: String) {
        _state.value = _state.value.copy(isLoading = true)
        when (val result = repository.search(query, isFavorite = false)) {
            is Result.Success -> {
                _state.value = _state.value.copy(
                    books = result.data,
                    isLoading = false,
                    error = "TEst message error"
                )
            }
            is Result.Failure -> {
                _state.value = _state.value.copy(
                    isLoading = false,
                    error = result.exception.message
                )
            }
        }
    }

    private suspend fun filterBooks(query: String) {
        _state.value = _state.value.copy(isLoading = true)
        when (val result = repository.search(query, isFavorite = false)) {
            is Result.Success -> {
                _state.value = _state.value.copy(
                    books = result.data,
                    isLoading = false,
                    error = null
                )
            }
            is Result.Failure -> {
                _state.value = _state.value.copy(
                    isLoading = false,
                    error = result.exception.message
                )
            }
        }
    }

    private suspend fun toggleFavorite(id: Int, isFavorite: Boolean) {
        _state.value = _state.value.copy(isLoading = true)
        when (val result = repository.favoriteMark(id, isFavorite)) {
            is Result.Success -> {
                // Refresh favorite books list after toggling favorite status
                loadFavorites()
            }
            is Result.Failure -> {
                _state.value = _state.value.copy(
                    isLoading = false,
                    error = result.exception.message
                )
            }
        }
    }

    private suspend fun navigateTo(screen: Screen) {
        _state.value = _state.value.copy(routing = screen)
    }

    private suspend fun syncBooks() {
        _state.value = _state.value.copy(isLoading = true)
        when (val result = repository.syncBooks()) {
            is Result.Success -> {
                loadBooks()  // Refresh book list after syncing
            }
            is Result.Failure -> {
                _state.value = _state.value.copy(
                    isLoading = false,
                    error = result.exception.message
                )
            }
        }
    }

    private fun hideError() {
        _state.value = _state.value.copy(error = null)
    }
}