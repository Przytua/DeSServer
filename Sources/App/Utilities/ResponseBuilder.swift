//
//  ResponseBuilder.swift
//  App
//
//  Created by Łukasz Przytuła on 04.03.2018.
//

import Vapor
import Foundation

class ResponseBuilder {
    
    func response(with data: Data) -> Response {
        var base64Data = data.base64EncodedData()
        base64Data.append([0x0a], count: 1)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss 'GMT'"
        let formattedDate = dateFormatter.string(from: Date())
        return Response(status: .ok, headers: ["Date": formattedDate, "Connection": "close", "Content-Type": "text/html; charset=UTF-8", "Server": "Apache"], body: base64Data)
    }
}
