//
//  CoreDataManager.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-29.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    var persistentController: PersistenceController
    
    private init() {
        persistentController = PersistenceController(inMemory: false)
    }
    
    @MainActor
    static let preview: CoreDataManager = {
        let persistance = PersistenceController.preview
        let result = CoreDataManager()
        result.persistentController = persistance
        
        for i in 1..<10 {
            let newItem = BookItem(context: persistance.container.viewContext)
            newItem.id = Int32(i)
            newItem.author = "Best Author Test"
            newItem.title = "Loren ipsum test strint"
            newItem.coverImageURL = "https://loremflickr.com/640/480/abstract?lock=\(i)"
            newItem.bookDescription = "Loren ipsum test strint, Loren ipsum test strint, Loren ipsum test strint, Loren ipsum test strint"
            newItem.isFavorite = ((i % 3) != 0)
        }
        do {
            try persistance.container.viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        
        return result
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentController.container.viewContext
    }
    
    // MARK: - CRUD Operations
    
    func addBook(id: Int, title: String, author: String, coverImageURL: String?, description: String?) {
        let book = BookItem(context: viewContext)
        book.id = Int32(id)
        book.title = title
        book.author = author
        book.coverImageURL = coverImageURL
        book.bookDescription = description
        book.isFavorite = false
        
        saveContext()
    }
    
    func removeBook(by id: Int) {
        if let book = fetchBook(by: id) {
            viewContext.delete(book)
            saveContext()
        }
    }
    
    func fetchBooks() -> [BookItem] {
        let fetchRequest: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch books: \(error)")
            return []
        }
    }
    
    func fetchBook(by id: Int) -> BookItem? {
        let fetchRequest: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            return try viewContext.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch book by id: \(error)")
            return nil
        }
    }
    
    func searchBooks(by titleOrAuthor: String) -> [BookItem] {
        let fetchRequest: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR author CONTAINS[cd] %@", titleOrAuthor, titleOrAuthor)
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to search books: \(error)")
            return []
        }
    }
    
    // MARK: - Favorite Operations
    
    func markBookAsFavorite(by id: Int) {
        if let book = fetchBook(by: id) {
            book.isFavorite = true
            saveContext()
        }
    }
    
    func removeBookFromFavorites(by id: Int) {
        if let book = fetchBook(by: id) {
            book.isFavorite = false
            saveContext()
        }
    }
    
    func fetchFavoriteBooks() -> [BookItem] {
        let fetchRequest: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch favorite books: \(error)")
            return []
        }
    }
    
    // MARK: - Sync
    func syncBooks(books: [Book]) {
       let existingBooks = fetchBooksByIds(books.map { Int($0.id) })
       
       for book in books {
           if let existingBook = existingBooks.first(where: { $0.id == Int(book.id) }) {
               if existingBook.title != book.title ||
                  existingBook.author != book.author ||
                  existingBook.coverImageURL != book.coverImageURL?.absoluteString ||
                  existingBook.bookDescription != book.text {
                   
                   existingBook.title = book.title
                   existingBook.author = book.author
                   existingBook.coverImageURL = book.coverImageURL?.absoluteString
                   existingBook.bookDescription = book.text
               }
           } else {
               let newBookItem = BookItem(context: viewContext)
               newBookItem.id = Int32(book.id)
               newBookItem.title = book.title
               newBookItem.author = book.author
               newBookItem.coverImageURL = book.coverImageURL?.absoluteString
               newBookItem.bookDescription = book.text
               newBookItem.isFavorite = false
           }
       }
       
       saveContext()
   }
   
   private func fetchBooksByIds(_ ids: [Int]) -> [BookItem] {
       let fetchRequest: NSFetchRequest<BookItem> = BookItem.fetchRequest()
       fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
       
       do {
           return try viewContext.fetch(fetchRequest)
       } catch {
           print("Failed to fetch books by ids: \(error)")
           return []
       }
   }
    
    // MARK: - Save Context
    
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
