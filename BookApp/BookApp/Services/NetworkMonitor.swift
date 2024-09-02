//
//  NetworkMonitor.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-31.
//

import Foundation
import Network

class NetworkMonitor:NetworkMonitoring {
    private let monitor: NWPathMonitor
    private let monitorQueue = DispatchQueue(label: "NetworkMonitorQueue")

    init() {
        self.monitor = NWPathMonitor()
        self.monitor.start(queue: monitorQueue)
    }

    deinit {
        monitor.cancel()
    }

    var statusStream: AsyncStream<Bool> {
        AsyncStream { continuation in
            monitor.pathUpdateHandler = { path in
                continuation.yield(path.status == .satisfied)
            }
            
            continuation.onTermination = { _ in
                self.monitor.cancel()
            }
        }
    }
}
