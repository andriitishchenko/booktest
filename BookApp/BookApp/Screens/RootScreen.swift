//
//  RootScreen.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-27.
//
//

import SwiftUI

struct RootScreen: View {
    @StateObject var intentHandler: BookIntentHandler
    @State private var scale: CGFloat = 0.5
    
    init(intentHandler: BookIntentHandler) {
        _intentHandler = StateObject(wrappedValue: intentHandler)
    }
    
    var body: some View {
        ZStack {
            VStack {
                switch intentHandler.state.routing {
                case .home:
                    HomeScreen(intentHandler: intentHandler)
                case .details(let book):
                    BookDetailsScreen(book: book, intentHandler: intentHandler)
                case .favorites:
                    FavoritesScreen(intentHandler: intentHandler)
                }
            }
            
            if intentHandler.state.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .green))
                    .frame(width: 100, height: 100) // Adjusted size
                    .background(Color.white.opacity(0.8)) // Slightly less opacity for better visibility
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding()
                    .scaleEffect(scale)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            scale = 1.2
                        }
                    }
            }
            
            if let errorMessage = intentHandler.state.error, !errorMessage.isEmpty {
                VStack {
                    ErrorPopupView(message: errorMessage)
                        .transition(.scale) // More appropriate transition for the popup
                        .onTapGesture {
                            Task {
                                await intentHandler.handle(.hideError)
                            }
                        }
                    Spacer()
                }
            }
        }
    }
}


struct RootScreen_Previews: PreviewProvider {
    static var previews: some View {
        let localSt = LocalStorageSource(coreDataManager: CoreDataManager.preview)
        
        let restClient = RestClient(environment: .production)
        let remoteSR = RemoteSource(restClient: restClient)
                
        let repo = BookRepository(localSource: localSt, remoteSource: remoteSR)
        
        let intentHandler = BookIntentHandler(repository: repo)
        
        RootScreen(intentHandler:intentHandler)
    }
}
