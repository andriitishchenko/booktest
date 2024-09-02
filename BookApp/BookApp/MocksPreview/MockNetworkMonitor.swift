//
//  MockNetworkMonitor.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-31.
//

import Foundation

class MockNetworkMonitor: NetworkMonitoring {
    private var continuation: AsyncStream<Bool>.Continuation?
    
    var statusStream: AsyncStream<Bool> {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }
    
    // Simulate network status changes
    func simulateNetworkChange(isConnected: Bool) {
        continuation?.yield(isConnected)
    }
    
    // Optional: You could add a function to simulate the end of the stream
    func finish() {
        continuation?.finish()
    }
}
