package com.example.booksdemo.source

import com.example.booksdemo.models.Book
import com.example.booksdemo.repository.Result
import com.example.booksdemo.db.BookDao
import com.example.booksdemo.models.toEntity

class LocalStorageSourceImpl(private val bookDao: BookDao) : LocalStorageSource {

    override suspend fun syncBooks(books: List<Book>): Result<Unit> {
        return try {
            bookDao.insertBooks(books.map { it.toEntity() })
            Result.Success(Unit)
        } catch (e: Exception) {
            handleLocalError(e, "syncBooks")
            Result.Failure(e)
        }
    }

    override suspend fun fetchBooks(): Result<List<Book>> {
        return try {
            val books = bookDao.fetchBooks().map { it.toBook() }
            Result.Success(books)
        } catch (e: Exception) {
            handleLocalError(e, "fetchBooks")
            Result.Failure(e)
        }
    }

    override suspend fun fetchFavorites(): Result<List<Book>> {
        return try {
            val favorites = bookDao.fetchFavorites().map { it.toBook() }
            Result.Success(favorites)
        } catch (e: Exception) {
            handleLocalError(e, "fetchFavorites")
            Result.Failure(e)
        }
    }

    override suspend fun searchBooks(query: String, isFavorite: Boolean): Result<List<Book>> {
        return try {
            val formattedQuery = "%$query%"  // Format the query for SQL LIKE
            val books = if (isFavorite) {
                bookDao.fetchFavorites().filter { it.title.contains(query, ignoreCase = true) || it.author.contains(query, ignoreCase = true) }
            } else {
                bookDao.searchBooks(formattedQuery)
            }.map { it.toBook() }
            Result.Success(books)
        } catch (e: Exception) {
            handleLocalError(e, "searchBooks")
            Result.Failure(e)
        }
    }

    override suspend fun markAsFavorite(bookId: Int, isFavorite: Boolean): Result<Unit> {
        return try {
            bookDao.updateFavoriteStatus(bookId, isFavorite)
            Result.Success(Unit)
        } catch (e: Exception) {
            handleLocalError(e, "markAsFavorite")
            Result.Failure(e)
        }
    }

    private fun handleLocalError(exception: Exception, functionName: String) {
        // Log the error for diagnostic purposes
        println("Error in $functionName: ${exception.message}")

        // Optionally, notify the user or send logs to a remote server
        // You can use a specific error handling mechanism based on the type of error
    }
}