//
//  NetworkMonitoringProtocol.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-31.
//

import Foundation

protocol NetworkMonitoring {
    var statusStream: AsyncStream<Bool> { get }
}
