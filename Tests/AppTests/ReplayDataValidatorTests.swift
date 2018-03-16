import XCTest
import Testing
import HTTP
import Sockets
@testable import Vapor
@testable import App

class ReplayDataValidatorTests: TestCase {
    
    let replayDataValidator = ReplayDataValidator()
    
    func testValidate() throws {
        let replayData = "eNqF0V1IU2EYB/D/aZJRhBFR0SQotE9zsVYuykOIFiWURVlBsKTQEDI1DZwX1SqSQgwq+mJspYFoN+EuouZezp6L1II+KT9u3uUhrMB2ERQk2LOPLs44p/7w54H398AL7wvADs45QNHs5/eXBKYdJI9khwf1mFiUs5jPIRWUV/DUHH132TeQbPVEfDk1Qrkyy+DqyD52N8ne1ZHWz3liqSuY4bvYt5H8WVes7bWLlcO/Mnw3+2aSfQXqnFNrxcLOgb9+FMjT1NFcdhdJ30cL7/yPP0j7sIV3/ds/NKf8wmxzDw2xbyR50W/ux3emvK3K1LeOfGcvInnn29ObNceEu+xQwuMKUJ94n6LoWfYyihWe2TLmWyGcY20Jh4LtSXcuOMxeSbH3j57ld68XnhMDBi9Y52Wvpk/ePeHroUrhezGV8Hl8f9LX/G5nb6Jx26X++vgTcS//h8Ed7w6yd9D4w0C/Pj8iopMho/uD7FHSd/SogVfFIt7iMri71lMSxHLS61ZlOs9CTX1by36S9NvdFv6a/TTpvR0WPpTynikLH0z7LXN/40z7AXMPP2dvZF9m7o83sTewZ5l56is4M8pzAf9VKJdfQvFcm04HSnspbHO7kHWjFDOX6Mi+P8HbTdwGwPaF+5U7mdyFbQIVaIQXLbzRjCqY5A9EPG4N"
        
        XCTAssertTrue(replayDataValidator.validate(replayData: replayData))
    }
}

// MARK: Manifest

extension ReplayDataValidatorTests {
    static let allTests = [
        ("testValidate", testValidate),
    ]
}
