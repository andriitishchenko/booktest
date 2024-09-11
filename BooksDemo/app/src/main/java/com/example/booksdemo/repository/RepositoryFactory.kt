package com.example.booksdemo.repository

import com.example.booksdemo.intent.BookIntentHandler

interface RepositoryFactory {
    fun createBookRepository(): BookRepository
    fun createBookIntentHandler(): BookIntentHandler
}
