package com.example.booksdemo.repository

sealed class Result<out T> {
    data class Success<out T>(val data: T) : Result<T>()
    data class Failure(val exception: Throwable) : Result<Nothing>()

    inline fun <R> mapCatching(transform: (T) -> R): Result<R> {
        return when (this) {
            is Success -> {
                try {
                    Success(transform(data))
                } catch (e: Exception) {
                    Failure(e)
                }
            }
            is Failure -> this
        }
    }
}