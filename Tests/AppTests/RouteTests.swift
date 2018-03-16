import XCTest
import Foundation
import Testing
import HTTP
@testable import Vapor
@testable import App

/// This file shows an example of testing 
/// routes through the Droplet.

class RouteTests: TestCase {
    let drop = try! Droplet.testable()
    
    func testFavicon() throws {
        try drop
            .testResponse(to: .get, at: "favicon.ico")
            .assertStatus(is: .ok)
    }

    func testMain() throws {
        try drop
            .testResponse(to: .get, at: "/")
            .assertStatus(is: .ok)
    }
    
    func testLogsWithoutPage() throws {
        try drop
            .testResponse(to: .get, at: "/logs")
            .assertStatus(is: .seeOther)
    }
    
    func testLogs() throws {
        try drop
            .testResponse(to: .get, at: "/logs/1")
            .assertStatus(is: .ok)
    }
}

// MARK: Manifest

extension RouteTests {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testFavicon", testFavicon),
        ("testMain", testMain),
        ("testLogsWithoutPage", testLogsWithoutPage),
        ("testLogs", testLogs),
    ]
}
