import Vapor
import FluentProvider
import HTTP
import Foundation

final class RequestLog: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the requestLog
    var endpoint: String
    var requestHeaders: String
    var requestBody: Bytes
    var responseHeaders: String
    var responseBody: Bytes
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let endpoint = "endpoint"
        static let requestHeaders = "request_headers"
        static let requestBody = "request_body"
        static let responseHeaders = "response_headers"
        static let responseBody = "response_body"
    }

    /// Creates a new RequestLog
    init(endpoint: String,
         requestHeaders: String,
         requestBody: Bytes = [],
         responseHeaders: String,
         responseBody: Bytes = []) {
        self.endpoint = endpoint
        self.requestHeaders = requestHeaders
        self.requestBody = requestBody
        self.responseHeaders = responseHeaders
        self.responseBody = responseBody
    }

    // MARK: Fluent Serialization

    /// Initializes the RequestLog from the
    /// database row
    init(row: Row) throws {
        endpoint = try row.get(RequestLog.Keys.endpoint)
        requestHeaders = try row.get(RequestLog.Keys.requestHeaders)
        if let requestBody = try? row.get(RequestLog.Keys.requestBody) as StructuredData,
            let bytes = requestBody.bytes{
            self.requestBody = bytes
        } else {
            self.requestBody = []
        }
        responseHeaders = try row.get(RequestLog.Keys.responseHeaders)
        if let responseBody = try? row.get(RequestLog.Keys.responseBody) as StructuredData,
            let bytes = responseBody.bytes{
            self.responseBody = bytes
        } else {
            self.responseBody = []
        }
    }

    // Serializes the RequestLog to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(RequestLog.Keys.endpoint, endpoint)
        try row.set(RequestLog.Keys.requestHeaders, requestHeaders)
        try row.set(RequestLog.Keys.requestBody, StructuredData.bytes(requestBody))
        try row.set(RequestLog.Keys.responseHeaders, responseHeaders)
        try row.set(RequestLog.Keys.responseBody, StructuredData.bytes(responseBody))
        return row
    }
}

// MARK: Fluent Preparation

extension RequestLog: Preparation {
    /// Prepares a table/collection in the database
    /// for storing RequestLogs
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.custom(RequestLog.Keys.endpoint, type: "TEXT")
            builder.custom(RequestLog.Keys.requestHeaders, type: "TEXT")
            builder.bytes(RequestLog.Keys.requestBody)
            builder.custom(RequestLog.Keys.responseHeaders, type: "TEXT")
            builder.bytes(RequestLog.Keys.responseBody)
        }
    }

    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new RequestLog (POST /requestLogs)
//     - Fetching a requestLog (GET /requestLogs, GET /requestLogs/:id)
//
extension RequestLog: JSONConvertible {
    convenience init(json: JSON) throws {
        func bytesArray(from string: String) -> [UInt8] {
            let hexa = Array(string)
            return stride(from: 0, to: string.count, by: 2).flatMap { UInt8(String(hexa[$0..<$0.advanced(by: 2)]), radix: 16) }
        }
        
        var requestBodyBytes: [UInt8] = []
        if let requestBody: String = try json.get(RequestLog.Keys.requestBody)  {
            requestBodyBytes = bytesArray(from: requestBody)
        }
        
        var responseBodyBytes: [UInt8] = []
        if let responseBody: String = try json.get(RequestLog.Keys.responseBody),
            let responseData = responseBody.data(using: .utf8) {
            responseBodyBytes = [UInt8](responseData)
        }
        
        self.init(
            endpoint: try json.get(RequestLog.Keys.endpoint),
            requestHeaders: try json.get(RequestLog.Keys.requestHeaders),
            requestBody: requestBodyBytes,
            responseHeaders: try json.get(RequestLog.Keys.responseHeaders),
            responseBody: responseBodyBytes
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(RequestLog.Keys.id, id)
        try json.set(RequestLog.Keys.endpoint, endpoint)
        try json.set(RequestLog.Keys.requestHeaders, requestHeaders)
        let requestBodyHexString = requestBody.map { String(format: "%02hhx", $0) }.joined()
        try json.set(RequestLog.Keys.requestBody, requestBodyHexString)
        try json.set(RequestLog.Keys.responseHeaders, responseHeaders)
        let responseData = Data(bytes: responseBody)
        let responseBodyString = String(data: responseData, encoding: .utf8)
        try json.set(RequestLog.Keys.responseBody, responseBodyString)
        return json
    }
}

// MARK: HTTP

// This allows RequestLog models to be returned
// directly in route closures
extension RequestLog: ResponseRepresentable { }

// MARK: Update

// This allows the RequestLog model to be updated
// dynamically by the request.
extension RequestLog: Updateable {
    // Updateable keys are called when `requestLog.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<RequestLog>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(RequestLog.Keys.endpoint, String.self) { requestLog, endpoint in
                requestLog.endpoint = endpoint
            },
            UpdateableKey(RequestLog.Keys.requestHeaders, String.self) { requestLog, requestHeaders in
                requestLog.requestHeaders = requestHeaders
            },
            UpdateableKey(RequestLog.Keys.requestBody, Bytes.self) { requestLog, requestBody in
                requestLog.requestBody = requestBody
            },
            UpdateableKey(RequestLog.Keys.responseHeaders, String.self) { requestLog, responseHeaders in
                requestLog.responseHeaders = responseHeaders
            },
            UpdateableKey(RequestLog.Keys.responseBody, Bytes.self) { requestLog, responseBody in
                requestLog.responseBody = responseBody
            }
        ]
    }
}
