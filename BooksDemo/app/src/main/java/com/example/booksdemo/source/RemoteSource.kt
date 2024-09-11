package com.example.booksdemo.source

import com.example.booksdemo.models.BookConvertible
import com.example.booksdemo.repository.Result

interface RemoteSource {
    suspend fun fetchBooks(): Result<List<BookConvertible>>
    suspend fun fetchBookById(id: Int): Result<BookConvertible>
}