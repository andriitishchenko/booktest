# BookApp

BookApp is a simple iOS application built using Swift that allows users to browse, search, and mark books as favorites. The app fetches book data from a remote server and also supports offline functionality through local storage. Additionally, it monitors network connectivity and handles errors gracefully.

## Table of Contents

- [Architecture](#architecture)
- [Main Classes](#main-classes)
  - [BookAppApp](#bookappapp)
  - [BookIntentHandler](#bookintenthandler)
  - [BookRepository](#bookrepository)
  - [RestClient](#restclient)
  - [LocalStorageSource](#localstoragesource)
  - [NetworkMonitor](#networkmonitor)
- [Installation](#installation)
- [Usage](#usage)
- [Testing](#testing)
- [License](#license)

## Architecture

The application is designed using the **MVI (Model-View-Intent)** architecture pattern.

- **Model**: This layer is responsible for managing the application's data and business logic. It includes classes such as `BookRepository`, `RestClient`, `LocalStorageSource`, and `NetworkMonitor`. The `BookRepository` acts as the single source of truth, interacting with both remote and local data sources.

- **View**: The `View` layer is represented by SwiftUI views like `RootScreen`, `HomeScreen`, `BookDetailsScreen`, and `FavoritesScreen`. These views observe the state from the `BookIntentHandler` and render the UI accordingly.

- **Intent**: The `Intent` layer, handled by `BookIntentHandler`, manages the user’s intentions and side effects. It receives user actions and other events (e.g., network status changes), processes them, and updates the `Model`. The `BookIntentHandler` maintains the state that the `View` observes and responds to.

This architecture ensures a unidirectional data flow and clear separation of concerns, making the app more maintainable and testable.

## Main Classes

### BookAppApp

`BookAppApp` is the main entry point of the application. It initializes the necessary components such as the `RestClient`, `LocalStorageSource`, and `BookRepository`, and then sets up the `BookIntentHandler` to manage the app's state and actions.

### BookIntentHandler

`BookIntentHandler` is responsible for handling user actions and updating the app's state. It uses `@Published` properties to manage state changes, which are observed by the SwiftUI views. It handles actions such as loading books, searching books, and managing favorites.

### BookRepository

`BookRepository` is the central class that interacts with both local and remote data sources. It retrieves books from either the `RestClient` (remote source) or `LocalStorageSource` (local source), depending on the network availability and other conditions.

### RestClient

`RestClient` is responsible for making HTTP requests to the remote API to fetch book data. It uses Swift's `async/await` for network calls and handles JSON parsing, error handling, and response validation.

### LocalStorageSource

`LocalStorageSource` manages data persistence using Core Data. It handles saving, fetching, and updating books in the local database, allowing the app to function offline.

### NetworkMonitor

`NetworkMonitor` tracks the network connectivity status of the device. It provides a stream of connectivity changes that the app can observe to handle online and offline modes gracefully.

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/BookApp.git
