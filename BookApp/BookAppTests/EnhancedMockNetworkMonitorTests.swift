//
//  EnhancedMockNetworkMonitorTests.swift
//  BookAppTests
//
//  Created by Andrii Tishchenko on 2024-09-01.
//

import Foundation
import XCTest

// Actor to safely manage status changes in a concurrent environment
actor StatusCollector {
    private(set) var statusChanges: [Bool] = []
    
    func addStatus(_ status: Bool) {
        statusChanges.append(status)
    }
}

class EnhancedMockNetworkMonitorTests: XCTestCase {
    
    func testNetworkStatusChanges() async {
        let monitor = EnhancedMockNetworkMonitor()
        let collector = StatusCollector()
        
        let expectation = XCTestExpectation(description: "Receive all network status changes")
        
        Task {
            var count = 0
            for await status in monitor.statusStream {
                await collector.addStatus(status)
                count += 1
                if count == 3 {
                    expectation.fulfill() // Fulfill when all expected changes are received
                }
            }
        }
        
        await fulfillment(of: [expectation], timeout: 6.0)
        
        let statusChanges = await collector.statusChanges
        XCTAssertEqual(statusChanges, [true, false, true], "The network status changes should match the expected sequence.")
    }
}
