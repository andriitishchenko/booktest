package com.example.booksdemo.db
import androidx.room.Entity
import androidx.room.PrimaryKey
import com.example.booksdemo.models.Book

@Entity(tableName = "books")
data class BookEntity(
    @PrimaryKey val id: Int,
    val title: String,
    val author: String,
    val description: String?,
    val coverImageUrl: String?,
    val isFavorite: Boolean = false
) {
    fun toBook(): Book {
        return Book(
            id = id,
            title = title,
            author = author,
            description = description,
            coverImageUrl = coverImageUrl,
            isFavorite = isFavorite
        )
    }

    companion object {
        fun fromBook(book: Book): BookEntity {
            return BookEntity(
                id = book.id,
                title = book.title,
                author = book.author,
                description = book.description,
                coverImageUrl = book.coverImageUrl,
                isFavorite = book.isFavorite
            )
        }
    }
}