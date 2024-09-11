package com.example.booksdemo.screen
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.ExperimentalMaterialApi
import androidx.compose.material.FractionalThreshold
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.rememberSwipeableState
import androidx.compose.material.swipeable
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import com.example.booksdemo.intent.BookIntent
import com.example.booksdemo.intent.BookIntentHandlerInterface
import com.example.booksdemo.intent.Screen
import com.example.booksdemo.preview.mockIntentHandler
import com.example.booksdemo.screen.view.BookRowView
import kotlinx.coroutines.launch
import kotlin.math.roundToInt


@OptIn(ExperimentalMaterial3Api::class, ExperimentalMaterialApi::class)
@Composable
fun FavoritesScreen(
    intentHandler: BookIntentHandlerInterface
) {
    val state by intentHandler.state.collectAsState()
    val coroutineScope = rememberCoroutineScope()
    var showDialog by remember { mutableStateOf(false) }
    var bookToRemove by remember { mutableStateOf<Int?>(null) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Favorites") },
                navigationIcon = {
                    IconButton(onClick = {
                        // Navigate to Home
                        coroutineScope.launch {
                            intentHandler.handle(BookIntent.NavigateTo(Screen.Home))
                        }
                    }) {
                        Icon(Icons.Default.Home, contentDescription = "Home")
                    }
                }
            )
        }
    ) { paddingValues ->
        if (state.favorites.isEmpty()) {
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                Text("No favorite books available", style = MaterialTheme.typography.bodyLarge)
            }
        } else {
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues)
            ) {
                items(state.favorites) { bookId ->
                    val book = state.books.find { it.id == bookId }
                    if (book != null) {
                        // Each book item with swipe-to-remove functionality
                        var swipeOffset by remember { mutableStateOf(0f) }
                        val swipeableState = rememberSwipeableState(initialValue = 0)
                        val anchors = mapOf(0f to 0, -300f to 1) // swipe to remove threshold

                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .swipeable(
                                    state = swipeableState,
                                    anchors = anchors,
                                    thresholds = { _, _ -> FractionalThreshold(0.3f) },
                                    orientation = Orientation.Horizontal
                                )
                                .offset { IntOffset(swipeOffset.roundToInt(), 0) }
                                .clickable {
                                    // Navigate to BookDetailsScreen when clicked
                                    coroutineScope.launch {
                                        intentHandler.handle(BookIntent.NavigateTo(Screen.Details(book.id)))
                                    }
                                }
                        ) {
                            // Reusing BookRowView here
                            BookRowView(
                                book = book,
                                onClick = {
                                    coroutineScope.launch {
                                        intentHandler.handle(BookIntent.NavigateTo(Screen.Details(book.id)))
                                    }
                                },
                                modifier = Modifier.padding(16.dp)
                            )
                        }

                        LaunchedEffect(swipeableState.currentValue) {
                            if (swipeableState.currentValue == 1) {
                                // Show confirmation dialog before removing
                                bookToRemove = book.id
                                showDialog = true
                            }
                        }
                    }
                }
            }
        }

        // Confirmation Dialog
        if (showDialog) {
            AlertDialog(
                onDismissRequest = { showDialog = false },
                title = { Text("Remove from Favorites") },
                text = { Text("Are you sure you want to remove this book from your favorites?") },
                confirmButton = {
                    TextButton(onClick = {
                        coroutineScope.launch {
                            intentHandler.handle(BookIntent.ToggleFavorite(bookToRemove!!, false))
                        }
                        showDialog = false
                    }) {
                        Text("Yes")
                    }
                },
                dismissButton = {
                    TextButton(onClick = {
                        showDialog = false
                    }) {
                        Text("No")
                    }
                }
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun FavoritesScreenPreview() {
    FavoritesScreen(intentHandler = mockIntentHandler)
}