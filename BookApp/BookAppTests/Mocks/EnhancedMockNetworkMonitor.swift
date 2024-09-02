//
//  EnhancedMockNetworkMonitor.swift
//  BookAppTests
//
//  Created by Andrii Tishchenko on 2024-09-01.
//

import Foundation
@testable import BookApp


class EnhancedMockNetworkMonitor: NetworkMonitoring {
    var statusStream = AsyncStream<Bool> { continuation in
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            continuation.yield(true) // Online
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            continuation.yield(false) // Offline
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            continuation.yield(true) // Back Online
        }
    }
}
