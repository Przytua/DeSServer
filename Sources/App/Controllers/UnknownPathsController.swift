//
//  UnknownPathsController.swift
//  App
//
//  Created by Łukasz Przytuła on 15.03.2018.
//

import Foundation

class UnknownPathsController {
    
    let log: LogProtocol
    
    init(log: LogProtocol) {
        self.log = log
    }
    
    func unimplemented(_ request: Request) throws -> Response {
        self.log.error("Unresolved path: \(request.uri.path) reached")
        log(request)
        return Response(status: .notImplemented)
    }
    
    func unknown(_ request: Request) throws -> Response {
        self.log.error("Unresolved path: \(request.uri.path) reached")
        log(request)
        return Response(status: .notFound)
    }
    
    func log(_ request: Request) {
        let requestLog = RequestLog(endpoint: request.uri.path,
                                    requestHeaders: String(describing: request.headers),
                                    requestBody: request.body.bytes ?? [],
                                    responseHeaders: "",
                                    responseBody: [])
        try? requestLog.save()
    }
}
