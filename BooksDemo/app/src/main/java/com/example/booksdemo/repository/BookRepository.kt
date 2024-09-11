package com.example.booksdemo.repository

import com.example.booksdemo.models.Book
import com.example.booksdemo.source.LocalStorageSource
import com.example.booksdemo.source.RemoteSource

class BookRepository(
    private val localStorage: LocalStorageSource,
    private val remoteSource: RemoteSource
) : BookRepositoryInterface {

    override suspend fun fetchBooks(): Result<List<Book>> {
        return  localStorage.fetchBooks()
    }

    override suspend fun fetchFavorites(): Result<List<Int>> {
        return localStorage.fetchFavorites().mapCatching { books ->
            books.map { it.id }
        }
    }

    override suspend fun search(query: String, isFavorite: Boolean): Result<List<Book>> {
        return localStorage.searchBooks(query, isFavorite)
    }

    override suspend fun favoriteMark(id: Int, isFavorite: Boolean): Result<Unit> {
        return localStorage.markAsFavorite(id, isFavorite)
    }

    override suspend fun syncBooks(): Result<Unit> {
        return remoteSource.fetchBooks().mapCatching { bookConvertibles ->
            val books = bookConvertibles.map { it.toBook() }
            localStorage.syncBooks(books)
        }
    }
}