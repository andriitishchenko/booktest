package com.example.booksdemo.restApi

enum class ApiEnvironment(val baseUrl: String) {
    PRODUCTION("https://66cf016f901aab2484207fcc.mockapi.io/api/v1"),
    DEVELOPMENT("https://myapidev.com/prod")
}