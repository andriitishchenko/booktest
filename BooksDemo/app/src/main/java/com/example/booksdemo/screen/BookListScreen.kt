package com.example.booksdemo.screen
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.booksdemo.intent.BookIntent
import com.example.booksdemo.intent.BookIntentHandlerInterface
import com.example.booksdemo.intent.Screen
import com.example.booksdemo.preview.mockIntentHandler
import com.example.booksdemo.screen.view.BookRowView
import com.example.booksdemo.screen.view.SearchField
import kotlinx.coroutines.launch


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BookListScreen(intentHandler: BookIntentHandlerInterface) {
//    var searchQuery by remember { mutableStateOf(TextFieldValue("")) }
    val state by intentHandler.state.collectAsState()
    val coroutineScope = rememberCoroutineScope()

    var searchQuery by remember { mutableStateOf("") }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Books") },
                actions = {

                    IconButton(
                        onClick = {
                            coroutineScope.launch {
                                intentHandler.handle(BookIntent.NavigateTo(Screen.Favorites))
                            }
                        }
                    ) {
                        Icon(
                            imageVector = Icons.Default.Star,
                            contentDescription = "Favorites",
                            tint = MaterialTheme.colorScheme.primary
                        )
                    }
                }
            )
        }
    ) { padding ->
    Column(modifier = Modifier
        .fillMaxWidth()
        .padding(PaddingValues(
            top = padding.calculateTopPadding(),
            bottom = 0.dp,
            end = 8.dp,
            start = 8.dp
        ))
    ) {
        // Add SearchField with callback
        SearchField(
            searchQuery = searchQuery,
            onValueChange = { query ->
                searchQuery = query
                coroutineScope.launch {
                    intentHandler.handle(BookIntent.FilterBooks(query)) // Filter books when search changes
                }
            }
        )
        Spacer(modifier = Modifier.height(8.dp))

        // Book List
        LazyColumn(
            modifier = Modifier.fillMaxSize()
        ) {
            items(state.books.size) { index ->
                val book = state.books[index]
                BookRowView(
                    book = book,
                    onClick = {
                        coroutineScope.launch {
                            intentHandler.handle(BookIntent.NavigateTo(Screen.Details(book.id)))
                        }
                    },
                    modifier = Modifier.padding(16.dp)
                )
                HorizontalDivider()
            }
        }
    }
}
}


@Preview(showBackground = true)
@Composable
fun BookListScreenPreview() {
    BookListScreen(intentHandler = mockIntentHandler)
}