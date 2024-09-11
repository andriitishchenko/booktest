package com.example.booksdemo.screen

import androidx.activity.compose.BackHandler
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.FavoriteBorder
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import coil.compose.rememberAsyncImagePainter
import com.example.booksdemo.intent.BookIntent
import com.example.booksdemo.intent.BookIntentHandlerInterface
import com.example.booksdemo.intent.Screen
import com.example.booksdemo.preview.mockIntentHandler
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BookDetailsScreen(bookId: Int, intentHandler: BookIntentHandlerInterface) {
    val state by intentHandler.state.collectAsState()
    val book = state.books.find { it.id == bookId }
    val coroutineScope = rememberCoroutineScope()

    BackHandler(true) {
        coroutineScope.launch {
            intentHandler.handle(BookIntent.NavigateTo(Screen.Home))
        }
    }

    if (book != null) {
        Scaffold(
            topBar = {
                TopAppBar(
                    title = { Text(book.title) },
                    navigationIcon = {

                        IconButton(onClick = {
                            coroutineScope.launch {
                                intentHandler.handle(BookIntent.NavigateTo(Screen.Home))
                            }
                        }) {
                            Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
                        }
                    },
                    actions = {
                        val isFavorite = state.favorites.contains(book.id)
                        IconButton(
                            onClick = {
                                coroutineScope.launch {
                                    intentHandler.handle(BookIntent.ToggleFavorite(book.id, !isFavorite))
                                }
                            }
                        ) {
                            Icon(
                                imageVector = if (isFavorite) Icons.Default.Favorite else Icons.Default.FavoriteBorder,
                                contentDescription = if (isFavorite) "Remove from Favorites" else "Add to Favorites",
                                tint = if (isFavorite) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurface
                            )
                        }
                    }
                )
            }
        ) { padding ->
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(padding)
                    .padding(16.dp)
            ) {
                // Cover Image
                Image(
                    painter = rememberAsyncImagePainter(book.coverImageUrl),
                    contentDescription = "Book Cover",
                    contentScale = ContentScale.Crop,
                    modifier = Modifier
                        .height(250.dp)
                        .fillMaxWidth()
                        .background(MaterialTheme.colorScheme.primary.copy(alpha = 0.5f))
                )

                Spacer(modifier = Modifier.height(16.dp))

                // Title and Author
                Text(book.title, style = MaterialTheme.typography.titleLarge)
                Text(book.author, style = MaterialTheme.typography.bodyLarge)

                Spacer(modifier = Modifier.height(16.dp))

                // Description
                Text(
                    book.description ?: "No description available.",
                    style = MaterialTheme.typography.bodyMedium
                )
            }
        }
    } else {
        Text("Book not found", style = MaterialTheme.typography.bodyLarge)
    }
}

@Preview(showBackground = true)
@Composable
fun BookDetailsScreenPreview() {
    BookDetailsScreen(bookId = 1, intentHandler = mockIntentHandler)
}