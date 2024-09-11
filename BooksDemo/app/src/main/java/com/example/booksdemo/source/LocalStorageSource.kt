package com.example.booksdemo.source

import com.example.booksdemo.models.Book
import com.example.booksdemo.repository.Result

interface LocalStorageSource {
    suspend fun syncBooks(books: List<Book>): Result<Unit>
    suspend fun fetchBooks(): Result<List<Book>>
    suspend fun fetchFavorites(): Result<List<Book>>
    suspend fun searchBooks(query: String, isFavorite: Boolean): Result<List<Book>>
    suspend fun markAsFavorite(bookId: Int, isFavorite: Boolean): Result<Unit>
}
