package com.example.booksdemo
import android.annotation.SuppressLint
import android.os.Bundle
import androidx.activity.ComponentActivity

import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.border

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.lifecycle.lifecycleScope
import com.example.booksdemo.restApi.ApiEnvironment
import com.example.booksdemo.intent.BookIntent
import com.example.booksdemo.intent.BookIntentHandler
import com.example.booksdemo.intent.Screen
import com.example.booksdemo.repository.DefaultRepositoryFactory
import com.example.booksdemo.screen.BookDetailsScreen
import com.example.booksdemo.screen.BookListScreen
import com.example.booksdemo.screen.FavoritesScreen
import com.example.booksdemo.screen.view.AnimatedSnackbarHost
import com.example.booksdemo.theme.BookAppTheme
import kotlinx.coroutines.launch

class MainActivity : ComponentActivity() {
    private lateinit var bookIntentHandler: BookIntentHandler
    private val repositoryFactory by lazy { DefaultRepositoryFactory(context = this, apiEnvironment = ApiEnvironment.PRODUCTION) }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        bookIntentHandler = repositoryFactory.createBookIntentHandler()

        lifecycleScope.launch {
            // Handle any loading or error states in the UI based on the result
            bookIntentHandler.handle(BookIntent.SyncBooks)
        }

        setContent {
            BookAppTheme {
                MainScreen()
            }
        }
    }

    @SuppressLint("UnusedMaterial3ScaffoldPaddingParameter")
    @OptIn(ExperimentalMaterial3Api::class)
    @Composable
    fun MainScreen() {
        val snackbarHostState = remember { SnackbarHostState() }
        val state by bookIntentHandler.state.collectAsState()

        Scaffold(
            snackbarHost = { AnimatedSnackbarHost(snackbarHostState) },
            content = {
                when (state.routing) {
                    is Screen.Home -> BookListScreen(intentHandler = bookIntentHandler)
                    is Screen.Details -> BookDetailsScreen(
                        bookId = (state.routing as Screen.Details).bookId,
                        intentHandler = bookIntentHandler
                    )
                    is Screen.Favorites -> FavoritesScreen(intentHandler = bookIntentHandler)
                    else -> {}
                }
            }
        )


//         Global Error Handling
        state.error?.let { errorMessage ->
            LaunchedEffect(errorMessage) {
                snackbarHostState.showSnackbar(
                    message = errorMessage,
                    actionLabel = "×"
                )
                bookIntentHandler.handle(BookIntent.HideError)
            }
        }

        // Global Loading Indicator
        if (state.isLoading) {
            Box(
                modifier = Modifier
                    .fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                Box(
                    modifier = Modifier
                        .size(150.dp)
                        .background(
                            color = Color.White
                        )
                        .border(width=1.dp,color=Color.Gray,
                            shape =  RoundedCornerShape(12.dp))
                    ,contentAlignment = Alignment.Center
                ) {
                    CircularProgressIndicator(
                        color = Color.Gray,
                        strokeWidth = 3.dp
                    )
                }
            }
        }
    }
}




