package com.example.booksdemo.models

import com.example.booksdemo.db.BookEntity

data class Book(
    val id: Int,
    val title: String,
    val author: String,
    val description: String?,
    val coverImageUrl: String?,
    var isFavorite: Boolean = false
)

fun BookEntity.toDomainModel(): Book {
    return Book(
        id = this.id,
        title = this.title,
        author = this.author,
        description = this.description,
        coverImageUrl = this.coverImageUrl,
        isFavorite = this.isFavorite
    )
}

fun Book.toEntity(): BookEntity {
    return BookEntity(
        id = this.id,
        title = this.title,
        author = this.author,
        description = this.description,
        coverImageUrl = this.coverImageUrl,
        isFavorite = this.isFavorite
    )
}