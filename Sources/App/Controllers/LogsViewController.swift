//
//  LogsViewController.swift
//  App
//
//  Created by Łukasz Przytuła on 04.03.2018.
//

import Vapor
import Foundation

class LogsViewController {
    
    public let viewRenderer: ViewRenderer
    
    init(viewRenderer: ViewRenderer) {
        self.viewRenderer = viewRenderer
    }
    
    func logsRedirect(_ req: Request) throws -> ResponseRepresentable {
        return Response(redirect: "logs/1")
    }
    
    func logs(_ req: Request) throws -> ResponseRepresentable {
        var page = 1
        if let pageParam = req.parameters["page"]?.int {
            page = pageParam
        }
        let offset = (page - 1) * pageSize
        let logs = try RequestLog.makeQuery().limit(pageSize, offset: offset).all().makeJSON()
        return try self.viewRenderer.make("logs", [ "logs": logs ])
    }
}
