import Vapor
import Foundation

let euServerAddress = "http://ds-eu-g.scej-online.jp:18666"
let jpServerAddress = "http://demons-souls.scej-online.jp:18666"
let usServerAddress = "http://ds-eu-g.scej-online.jp:18666"

let serverAddress = "192.168.1.136"

let ssResponse = """
<ss>0</ss>
<lang2></lang2>
<lang4></lang4>
<lang5></lang5>
<lang6></lang6>
<lang7></lang7>
<lang8></lang8>
<lang11></lang11>
<lang12></lang12>
<gameurl2>http://\(serverAddress):18000/cgi-bin/</gameurl2>
<gameurl4>http://\(serverAddress):18000/cgi-bin/</gameurl4>
<gameurl5>http://\(serverAddress):18000/cgi-bin/</gameurl5>
<gameurl6>http://\(serverAddress):18000/cgi-bin/</gameurl6>
<gameurl7>http://\(serverAddress):18000/cgi-bin/</gameurl7>
<gameurl8>http://\(serverAddress):18000/cgi-bin/</gameurl8>
<gameurl11>http://\(serverAddress):18000/cgi-bin/</gameurl11>
<gameurl12>http://\(serverAddress):18000/cgi-bin/</gameurl12>
<browserurl4></browserurl4>
<browserurl5></browserurl5>
<browserurl6></browserurl6>
<browserurl7></browserurl7>
<browserurl8></browserurl8>
<browserurl11></browserurl11>
<browserurl12></browserurl12>
<interval2>120</interval2>
<interval4>120</interval4>
<interval5>120</interval5>
<interval6>120</interval6>
<interval7>120</interval7>
<interval8>120</interval8>
<interval11>120</interval11>
<interval12>120</interval12>
<getWanderingGhostInterval>20</getWanderingGhostInterval>
<setWanderingGhostInterval>20</setWanderingGhostInterval>
<getBloodMessageNum>80</getBloodMessageNum>
<getReplayListNum>80</getReplayListNum>
<enableWanderingGhost>1</enableWanderingGhost>
"""

let ssData = (ssResponse).data(using: String.Encoding.utf8)
let ssBase64Response = ssData!.base64EncodedString(options: .lineLength64Characters)

extension Droplet {
    func setupRoutes() throws {
        try resource("requestLogs", RequestLogController.self)
        
        get("logs") { req in
            let logs = try RequestLog.all().makeJSON()
            return try self.view.make("logs", [ "logs": logs ])
        }
        
        get("demons-souls-eu/ss.info") { req in
            return ssResponse
        }
        
        get("demons-souls-asia/ss.info") { req in
            return ssResponse
        }
        
        get("demons-souls-us/ss.info") { req in
            return "ameryka"
        }
        
        post("demons-souls-eu/ss.info") { req in
            return ssResponse
        }
        
        post("demons-souls-asia/ss.info") { req in
            return ssResponse
        }
        
        post("demons-souls-us/ss.info") { req in
            return "ameryka"
        }
        
        all("/cgi-bin/*") { req in
            return self.redirect(req)
        }
        
        get("/cgi-bin/*") { req in
            return self.redirect(req)
        }
        
        post("/cgi-bin/*") { req in
            return self.redirect(req)
        }
        
        put("/cgi-bin/*") { req in
            return self.redirect(req)
        }
        
        patch("/cgi-bin/*") { req in
            return self.redirect(req)
        }
        
        delete("/cgi-bin/*") { req in
            return self.redirect(req)
        }
        
        options("/cgi-bin/*") { req in
            return self.redirect(req)
        }
    }
    
    func redirect(_ request: Request) -> Response {
        let redirectAddress = "\(euServerAddress)\(request.uri.path)"
        var redirectHeaders = request.headers
        redirectHeaders["HOST"] = nil
        redirectHeaders["content-type"] = nil
        redirectHeaders["content-length"] = nil
        let redirectRequest = Request(method: request.method,
                                      uri: redirectAddress,
                                      headers: redirectHeaders,
                                      body: request.body)
        let response = try! self.client.respond(to: redirectRequest)
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

