package com.example.booksdemo.intent

sealed class Screen {
    object Home : Screen()
    object Favorites : Screen()
    data class Details(val bookId: Int) : Screen()
}


sealed class BookIntent {
    object LoadBooks : BookIntent()
    object LoadFavorites : BookIntent()
    data class SearchBooks(val query: String) : BookIntent()
    data class FilterBooks(val query: String) : BookIntent()
    data class ToggleFavorite(val id: Int, val isFavorite: Boolean) : BookIntent()
    data class NavigateTo(val screen: Screen) : BookIntent()
    object SyncBooks : BookIntent()
    object HideError : BookIntent()
}