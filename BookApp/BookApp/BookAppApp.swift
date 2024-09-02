//
//  BookAppApp.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-27.
//

import SwiftUI

@main
struct BookAppApp: App {
    @StateObject private var intentHandler: BookIntentHandler
    
    init() {
        // UI Customizations for SearchBar and NavigationBar
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black

        UINavigationBar.appearance().tintColor = UIColor.white
        UIBarButtonItem.appearance().tintColor = UIColor.white
        
        // Initialize the intent handler asynchronously
        _intentHandler = StateObject(wrappedValue: BookIntentHandler(repository: Self.createRepository()))
    }
    
    var body: some Scene {
        WindowGroup {
            RootScreen(intentHandler: intentHandler)
                .task {
                    await intentHandler.handle(.syncBooks)
                }
        }
    }
    
    private static func createRepository() -> BookRepository {
        let localStorage = LocalStorageSource(coreDataManager: CoreDataManager.shared)
        let session:URLSession = URLSession.createConfiguredSession()
        let restClient = RestClient(environment: .production, session:session)
        let remoteStorage = RemoteSource(restClient: restClient)
        return BookRepository(localSource: localStorage, remoteSource: remoteStorage)
    }
}

