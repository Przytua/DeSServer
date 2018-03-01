import Vapor
import Foundation

let serverAddress = SoulsServerConfiguration.euServerAddress
let pageSize = 100

extension Droplet {
    
    func setupRoutes() throws {
        try resource("requestLogs", RequestLogController.self)
        
        get("logs") { req in
            return Response(redirect: "logs/1")
        }
        
        get("logs", ":page") { req in
            var page = 1
            if let pageParam = req.parameters["page"]?.int {
                page = pageParam
            }
            let offset = (page - 1) * pageSize
            let logs = try RequestLog.makeQuery().limit(pageSize, offset: offset).all().makeJSON()
            return try self.view.make("logs", [ "logs": logs ])
        }
        
        all("demons-souls-eu/ss.info") { req in
            return SoulsServerConfiguration.euResponse
        }
        
        all("demons-souls-asia/ss.info") { req in
            return SoulsServerConfiguration.jpResponse
        }
        
        all("demons-souls-us/ss.info") { req in
            return SoulsServerConfiguration.usResponse
        }
        
        all("*") { req in
            return self.redirect(req)
        }
        
        get("favicon.ico") { req in
            return try Response(filePath: "\(self.config.publicDir)/favicon.ico")
        }
        
        all("cgi-bin/login.spd") { req in
            var responseData: Data = Data(bytes: [1, 244, 2, 0, 0, 1, 1])
            let message = "Custom message"
            responseData.append(message.data(using: .utf8)!)
            
            return self.createResponse(with: responseData)
        }
        
        all("cgi-bin/getQWCData.spd") { req in
            let bytes: [UInt8]
            let pureBlack = false
            if (pureBlack) {
                bytes = [14, 61, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] // PBWT
            } else {
                bytes = [14, 61, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] // PWWT
            }
            let data = Data(bytes: bytes)
            return self.createResponse(with: data)
        }
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
    
    func createResponse(with data: Data) -> Response {
        var base64Data = data.base64EncodedData()
        base64Data.append([0x0a], count: 1)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss 'GMT'"
        let formattedDate = dateFormatter.string(from: Date())
        return Response(status: .ok, headers: ["Date": formattedDate, "Connection": "close", "Content-Type": "text/html; charset=UTF-8", "Server": "Apache"], body: base64Data)
    }
}

