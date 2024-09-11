package com.example.booksdemo.screen.view

import androidx.compose.animation.animateContentSize
import androidx.compose.animation.core.tween
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.Button
import androidx.compose.material3.Snackbar
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.SnackbarVisuals
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color

@Composable
fun CustomSnackbar(
    visuals: SnackbarVisuals,
    onDismiss: () -> Unit
) {
    Snackbar(
        containerColor = Color.Red,
        contentColor = Color.White,
        actionContentColor = Color.White,
        actionOnNewLine = false,
        content = {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = visuals.message,
                    modifier = Modifier.weight(2f),
                    color = Color.White
                )
                visuals.actionLabel?.let { actionLabel ->
                    Button(onClick = {
                        onDismiss()
                    }) {
                        Text(text = actionLabel)
                    }
                }
            }
        }
    )
}

@Composable
fun AnimatedSnackbarHost(
    snackbarHostState: SnackbarHostState
) {
    SnackbarHost(
        hostState = snackbarHostState,
        modifier = Modifier.animateContentSize(animationSpec = tween(durationMillis = 300))
    ) { snackbarData ->
        CustomSnackbar(
            visuals = snackbarData.visuals,
            onDismiss = { snackbarData.dismiss() }
        )
    }
}