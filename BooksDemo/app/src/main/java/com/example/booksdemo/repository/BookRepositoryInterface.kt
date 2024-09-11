package com.example.booksdemo.repository

import com.example.booksdemo.models.Book

interface BookRepositoryInterface {
    suspend fun fetchBooks(): Result<List<Book>>
    suspend fun fetchFavorites(): Result<List<Int>>
    suspend fun search(query: String, isFavorite: Boolean): Result<List<Book>>
    suspend fun favoriteMark(id: Int, isFavorite: Boolean): Result<Unit>
    suspend fun syncBooks(): Result<Unit>
}