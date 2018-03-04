import Vapor
import Foundation

let serverAddress = "http://212.71.239.147:18667" //SoulsServerConfiguration.usServerAddress
let pageSize = 100

extension Droplet {
    
    func setupRoutes() throws {
        let logsViewController = LogsViewController(viewRenderer: view)
        let redirectController = RedirectController(client: client, log: log)
        let infoController = InfoController()
        let loginController = LoginController(redirectController: redirectController)
        
        try resource("requestLogs", RequestLogController.self)
        get("logs", handler: logsViewController.logsRedirect)
        get("logs", ":page", handler: logsViewController.logs)
        
        all("*", handler: redirectController.redirect)
        get("favicon.ico") { req in
            return try Response(filePath: "\(self.config.publicDir)/favicon.ico")
        }
        
        all("demons-souls-eu/ss.info", handler: infoController.eu)
        all("demons-souls-asia/ss.info", handler: infoController.jp)
        all("demons-souls-us/ss.info", handler: infoController.us)
        
        all("cgi-bin/login.spd", handler: loginController.login)
        all("cgi-bin/getQWCData.spd", handler: loginController.getQWCData)
    }
}

