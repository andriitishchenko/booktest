package com.example.booksdemo.db

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query

@Dao
interface BookDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertBooks(books: List<BookEntity>)

    @Query("SELECT * FROM books")
    suspend fun fetchBooks(): List<BookEntity>

    @Query("SELECT * FROM books WHERE isFavorite = 1")
    suspend fun fetchFavorites(): List<BookEntity>

    @Query("SELECT * FROM books WHERE title LIKE :query OR author LIKE :query")
    suspend fun searchBooks(query: String): List<BookEntity>

    @Query("UPDATE books SET isFavorite = :isFavorite WHERE id = :bookId")
    suspend fun updateFavoriteStatus(bookId: Int, isFavorite: Boolean)
}
