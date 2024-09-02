//
//  BookIntentHandler.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-27.
//
import Foundation

enum BookIntent {
    case loadBooks
    case loadFavorite
    case searchBooks(query: String)
    case filterBooks(query: String)
    case favoriteMark(id: Int, isFavorite:Bool)
    case navigateTo(screen:RoutingState)
    case syncBooks
    case hideError
}

@MainActor
class BookIntentHandler: ObservableObject {
    @Published private(set) var state: BookState = .initial
    private let repository: Repository
    private var isConnected: Bool = false
    
    private let networkMonitor = NetworkMonitor()
    
    init(repository: Repository) {
        self.repository = repository
        
        Task {
            await monitorNetworkChanges(networkMonitor)
        }
    }
    
    private func monitorNetworkChanges(_ networkMonitor: NetworkMonitoring) async {
            for await connected in networkMonitor.statusStream {
                handleConnectionStatusChange(connected: connected)
            }
        }
        
    private func handleConnectionStatusChange(connected: Bool) {
            if connected && !isConnected {
                isConnected = true
                Task {
                    state = state.copy(error: "")
                    await syncBooks()
                }
            } else if !connected {
                isConnected = false
                state = state.copy(error: "No internet connection")
            }
    }
    
    func handle(_ intent: BookIntent) async {
        switch intent {
        case .loadBooks:
            await loadBooks()
            
        case .loadFavorite:
            await loadFavorite()
            
        case .navigateTo(screen: .details(let book)):
            state = state.copy(routing: .details(book))
        
        case .navigateTo(screen: .home):
            state = state.copy(routing: .home)
        
        case .navigateTo(screen: .favorites):
            state = state.copy(routing: .favorites)
            
        case .searchBooks(let query):
            await searchBooks(query)
            
        case .filterBooks(let query):
            filterBooks(query)
            
        case .favoriteMark(let id, let isFavorite):
            await updateFavoriteMark(id: id, isFavorite: isFavorite)
            
        case .syncBooks:
            await syncBooks()
            await loadFavorite()
            
        case .hideError:
             state = state.copy(error: "")
            
        default:
            state = state.copy(error: "Undefined handler")
        }
    }
    
    private func loadBooks() async {
        do {
            let books = try await repository.fetchBooks()
            state = state.copy(books: books)
        } catch {
            state = state.copy(error: "Failed to load books: \(error)")
        }
    }
    
    private func loadFavorite() async {
        do {
            let favorites = try await repository.fetchFavorites()
            state = state.copy(favorites: favorites)
        } catch {
            state = state.copy(error: "Failed to load favorites: \(error)")
        }
    }
    
    private func updateFavoriteMark(id: Int, isFavorite: Bool) async {
        do {
            try await repository.favoriteMark(id: id, isFavorite: isFavorite)
            await loadFavorite()
        } catch {
            state = state.copy(error: "Failed to update favorite status: \(error)")
        }
    }
    
    private func filterBooks(_ query: String) {
        let lowerQuery = query.lowercased()
        if !query.isEmpty {
            let books = state.books.filter { $0.title.lowercased().contains(lowerQuery) || $0.author.lowercased().contains(lowerQuery) }
            state = state.copy(searchResults: books)
        } else {
            state = state.copy(searchResults: [])
        }
    }
    
    private func searchBooks(_ query: String) async {
        // Assume its a search request to WEB, becouse we dont have an endpoint for search
        // just filter existing data for demo
        do {
            if !query.isEmpty {
                let books = try await repository.search(query: query, isFavorite: false)
                state = state.copy(books: books)
            } else {
                state = state.copy(books: [])
            }
        } catch {
            state = state.copy(error: "Failed to search books: \(error)")
        }
    }
    
    private func syncBooks() async {
        state = state.copy(isLoading: true)
        do {
            try await repository.syncBooks()
            let books = try await repository.fetchBooks()
            let favorites = try await repository.fetchFavorites()
            state = state.copy(books: books, favorites: favorites, searchResults: [], isLoading: false)
        } catch {
            state = state.copy(isLoading: false, error: "Failed to sync books: \(error.localizedDescription)")
        }
    }
}

