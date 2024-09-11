package com.example.booksdemo.restApi

import com.example.booksdemo.models.Book
import com.example.booksdemo.models.BookConvertible
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable(with = ApiBookSerializer::class)
data class ApiBook(
    val id: Int,
    val title: String,
    val author: String,
    val description: String,
    @SerialName("cover") val coverImageUrl: String
)
    : BookConvertible {
    override fun toBook(): Book {
        return toDomainModel()

    }
}


// Mapping extension function
fun ApiBook.toDomainModel(): Book {
    return Book(
        id = this.id,
        title = this.title,
        author = this.author,
        description = this.description,
        coverImageUrl = this.coverImageUrl,
        isFavorite = false // Assume API doesn't provide this, or handle it as needed
    )
}


