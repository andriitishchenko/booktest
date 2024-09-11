package com.example.booksdemo.screen.view

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp

@Composable
fun SearchField(
    searchQuery: String,
    onValueChange: (String) -> Unit, // Callback for handling search changes
) {
    BasicTextField(
        value = searchQuery,
        onValueChange = { onValueChange(it) }, // Use the callback to handle value changes
        modifier = Modifier
            .fillMaxWidth()
            .padding(2.dp)
            .border(
                width = 1.dp,
                color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.5f), // Border color
                shape = MaterialTheme.shapes.medium // Rounded corners
            )
            .background(MaterialTheme.colorScheme.surface, MaterialTheme.shapes.medium)
            .padding(2.dp),
        textStyle = MaterialTheme.typography.bodyLarge,
        decorationBox = { innerTextField ->
            Box(
                modifier = Modifier
                    .background(MaterialTheme.colorScheme.surface, MaterialTheme.shapes.medium)
                    .padding(horizontal = 16.dp, vertical = 16.dp)
                    .fillMaxWidth()
            ) {
                if (searchQuery.isEmpty()) {
                    Text(
                        text = "Search...",
                        style = MaterialTheme.typography.bodyLarge.copy(color = Color.Gray)
                    )
                }
                innerTextField() // Draw the input field
            }
        }
    )
}