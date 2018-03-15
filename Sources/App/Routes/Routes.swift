import Vapor
import Foundation

extension Droplet {
    
    func setupRoutes() throws {
        let logsViewController = LogsViewController(viewRenderer: view)
        let infoController = InfoController(config: config)
        let loginController = LoginController(log: log)
        let playersController = PlayersController(log: log)
        let worldTendencyController = WorldTendencyController(log: log)
        let messagesController = MessagesController(log: log, playersController: playersController)
        let ghostsController = GhostsController(log: log)
        let replayController = ReplayController(log: log)
        let sosController = SOSController(log: log)
        let unknownPathsController = UnknownPathsController(log: log)
        
        get("favicon.ico") { req in
            return try Response(filePath: "\(self.config.publicDir)/favicon.ico")
        }
        
        get("/", handler: logsViewController.logsRedirect)
        try resource("requestLogs", RequestLogController.self)
        get("logs", handler: logsViewController.logsRedirect)
        get("logs", ":page", handler: logsViewController.logs)
        
        try resource("serverSettings", ServerSettingController.self)
        
        all("demons-souls-eu/ss.info", handler: infoController.eu)
        all("demons-souls-asia/ss.info", handler: infoController.jp)
        all("demons-souls-us/ss.info", handler: infoController.us)
        
        all("cgi-bin/login.spd", handler: loginController.login)
        all("cgi-bin/getTimeMessage.spd", handler: loginController.getTimeMessage)
        
        all("cgi-bin/initializeCharacter.spd", handler: playersController.initializeCharacter)
        all("cgi-bin/getMultiPlayGrade.spd", handler: playersController.getMultiPlayGrade)
        all("cgi-bin/getBloodMessageGrade.spd", handler: playersController.getBloodMessageGrade)
        all("cgi-bin/initializeMultiPlay.spd", handler: playersController.initializeMultiPlay)
        all("cgi-bin/finalizeMultiPlay.spd", handler: playersController.finalizeMultiPlay)
        all("cgi-bin/updateOtherPlayerGrade.spd", handler: playersController.updateOtherPlayerGrade)
        
        all("cgi-bin/addQWCData.spd", handler: worldTendencyController.addQWCData)
        all("cgi-bin/getQWCData.spd", handler: worldTendencyController.getQWCData)
        
        all("cgi-bin/addBloodMessage.spd", handler: messagesController.addBloodMessage)
        all("cgi-bin/getBloodMessage.spd", handler: messagesController.getBloodMessage)
        all("cgi-bin/deleteBloodMessage.spd", handler: messagesController.deleteBloodMessage)
        all("cgi-bin/updateBloodMessageGrade.spd", handler: messagesController.updateBloodMessageGrade)
        
        all("cgi-bin/setWanderingGhost.spd", handler: ghostsController.setWanderingGhost)
        all("cgi-bin/getWanderingGhost.spd", handler: ghostsController.getWanderingGhost)
        
        all("cgi-bin/addReplayData.spd", handler: replayController.addReplayData)
        all("cgi-bin/getReplayList.spd", handler: replayController.getReplayList)
        all("cgi-bin/getReplayData.spd", handler: replayController.getReplayData)
        
        all("cgi-bin/addSosData.spd", handler: sosController.addSosData)
        all("cgi-bin/getSosData.spd", handler: sosController.getSosData)
        all("cgi-bin/checkSosData.spd", handler: sosController.checkSosData)
        all("cgi-bin/summonOtherCharacter.spd", handler: sosController.summonOtherCharacter)
        all("cgi-bin/summonBlackGhost.spd", handler: sosController.summonBlackGhost)
        all("cgi-bin/outOfBlock.spd", handler: sosController.outOfBlock)
        
        all("cgi-bin/getAgreement.spd", handler: unknownPathsController.unimplemented)
        all("cgi-bin/addNewAccount.spd", handler: unknownPathsController.unimplemented)
        
        all("*", handler: unknownPathsController.unknown)
    }
}

