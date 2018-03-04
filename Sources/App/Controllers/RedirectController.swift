//
//  RedirectController.swift
//  App
//
//  Created by Łukasz Przytuła on 04.03.2018.
//

import Vapor
import Foundation

class RedirectController {
    
    public let client: ClientFactoryProtocol
    public let log: LogProtocol
    
    init(client: ClientFactoryProtocol, log: LogProtocol) {
        self.client = client
        self.log = log
    }
    
    func redirect(_ request: Request) -> Response {
        let redirectAddress = "\(serverAddress)\(request.uri.path)"
        var redirectHeaders = request.headers
        redirectHeaders["HOST"] = nil
        redirectHeaders["content-type"] = nil
        redirectHeaders["content-length"] = nil
        let redirectRequest = Request(method: request.method,
                                      uri: redirectAddress,
                                      headers: redirectHeaders,
                                      body: request.body)
        guard let response = try? self.client.respond(to: redirectRequest) else {
            return Response(status: .forbidden)
        }
        let requestLog = RequestLog(endpoint: request.uri.path,
                                    requestHeaders: String(describing: request.headers),
                                    requestBody: request.body.bytes ?? [],
                                    responseHeaders: String(describing: response.headers),
                                    responseBody: response.body.bytes ?? [])
        do {
            try requestLog.save()
        } catch let error {
            self.log.error(error)
        }
        return response
    }
}
