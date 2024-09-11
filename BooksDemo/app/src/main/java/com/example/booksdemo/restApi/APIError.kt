package com.example.booksdemo.restApi

sealed class APIError : Exception() {
    data class ServerError(val statusCode: Int, override val message: String) : APIError()
    data class NetworkError(val exception: Exception) : APIError()
    data class DecodingError(val exception: Exception) : APIError()
    object UnknownError : APIError()
}