package com.example.booksdemo.intent

import com.example.booksdemo.models.Book

data class BookState(
    val books: List<Book> = emptyList(),
    val favorites: List<Int> = emptyList(),
    val searchResults: List<Book> = emptyList(),
    val isLoading: Boolean = true,
    val error: String? = "Error message",
    val routing: Screen = Screen.Home
)
