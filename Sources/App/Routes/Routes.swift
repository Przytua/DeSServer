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
        let worldTendencyController = WorldTendencyController(redirectController: redirectController)
        let messagesController = MessagesController(redirectController: redirectController)
        let ghostsController = GhostsController(redirectController: redirectController, log: log)
        let replayController = ReplayController(redirectController: redirectController, log: log)
        
        get("/", handler: logsViewController.logsRedirect)
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
        
        all("cgi-bin/addQWCData.spd", handler: worldTendencyController.addQWCData)
        all("cgi-bin/getQWCData.spd", handler: worldTendencyController.getQWCData)
        
        all("cgi-bin/addBloodMessage.spd", handler: messagesController.addBloodMessage)
        all("cgi-bin/getBloodMessage.spd", handler: messagesController.getBloodMessage)
        all("cgi-bin/deleteBloodMessage.spd", handler: messagesController.deleteBloodMessage)
        all("cgi-bin/updateBloodMessageGrade.spd", handler: messagesController.updateBloodMessageGrade)
        all("cgi-bin/getBloodMessageGrade.spd", handler: messagesController.getBloodMessageGrade)
        
        all("cgi-bin/setWanderingGhost.spd", handler: ghostsController.setWanderingGhost)
        all("cgi-bin/getWanderingGhost.spd", handler: ghostsController.getWanderingGhost)
        
        all("cgi-bin/addReplayData.spd", handler: replayController.addReplayData)
        all("cgi-bin/getReplayList.spd", handler: replayController.getReplayList)
        all("cgi-bin/getReplayData.spd", handler: replayController.getReplayData)
    }
}

