package com.example.booksdemo.source

import com.example.booksdemo.models.BookConvertible
import com.example.booksdemo.restApi.RestClient
import com.example.booksdemo.repository.Result


class RemoteSourceImpl(private val restClient: RestClient) : RemoteSource {

    override suspend fun fetchBooks(): Result<List<BookConvertible>> {
        return  restClient.fetchBooks()
    }

    override suspend fun fetchBookById(id: Int): Result<BookConvertible> {
        return  restClient.fetchBookById(id)
    }
}