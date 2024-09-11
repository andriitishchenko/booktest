package com.example.booksdemo.service

import kotlinx.coroutines.flow.Flow

interface ConnectionStatusServiceInterface {
    suspend fun isConnected(): Boolean
    fun observeConnectionStatus(): Flow<Boolean>
}