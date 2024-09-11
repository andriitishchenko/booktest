package com.example.booksdemo.service

import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.withContext

class ConnectionStatusService(context: Context) : ConnectionStatusServiceInterface {
    private val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    private val networkStatusFlow = MutableStateFlow(checkCurrentConnection())

    init {
        observeNetworkChanges()
    }

    override fun observeConnectionStatus(): Flow<Boolean> = networkStatusFlow

    // Suspend function to check connection status manually (from interface)
    override suspend fun isConnected(): Boolean {
        return networkStatusFlow.value
    }

    // Helper method to check the current network connection synchronously (private)
    private fun checkCurrentConnection(): Boolean {
        val activeNetwork = connectivityManager.activeNetworkInfo
        return activeNetwork?.isConnected == true
    }

    private fun observeNetworkChanges() {
        val networkCallback = object : ConnectivityManager.NetworkCallback() {
            override fun onAvailable(network: Network) {
                networkStatusFlow.value = true
            }

            override fun onLost(network: Network) {
                networkStatusFlow.value = false
            }
        }

        connectivityManager.registerDefaultNetworkCallback(networkCallback)
    }
}
