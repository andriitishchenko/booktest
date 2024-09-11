package com.example.booksdemo.intent

import kotlinx.coroutines.flow.StateFlow

interface BookIntentHandlerInterface {
    val state: StateFlow<BookState>
    suspend fun handle(intent: BookIntent)
}