//
//  SoulsServerConfiguration.swift
//  DeSServerPackageDescription
//
//  Created by Łukasz Przytuła on 30.11.2017.
//

import Foundation

let wanderingGhostInterval = 20

class SoulsServerConfiguration {
    
    let interval = 120
    let bloodMessageNum = 80
    let replayListNum = 80
    let enableWanderingGhost = 1
    
    func euResponse(serverAddress: String) -> String {
        return """
        <ss>0</ss>
        <lang2></lang2>
        <lang5></lang5>
        <lang6></lang6>
        <lang7></lang7>
        <lang8></lang8>
        <gameurl2>http://\(serverAddress):18000/cgi-bin/</gameurl2>
        <gameurl5>http://\(serverAddress):18000/cgi-bin/</gameurl5>
        <gameurl6>http://\(serverAddress):18000/cgi-bin/</gameurl6>
        <gameurl7>http://\(serverAddress):18000/cgi-bin/</gameurl7>
        <gameurl8>http://\(serverAddress):18000/cgi-bin/</gameurl8>
        <interval2>\(interval)</interval2>
        <interval5>\(interval)</interval5>
        <interval6>\(interval)</interval6>
        <interval7>\(interval)</interval7>
        <interval8>\(interval)</interval8>
        <getWanderingGhostInterval>\(wanderingGhostInterval)</getWanderingGhostInterval>
        <setWanderingGhostInterval>\(wanderingGhostInterval)</setWanderingGhostInterval>
        <getBloodMessageNum>\(bloodMessageNum)</getBloodMessageNum>
        <getReplayListNum>\(replayListNum)</getReplayListNum>
        <enableWanderingGhost>\(enableWanderingGhost)</enableWanderingGhost>
        """
    }
    
    func jpResponse(serverAddress: String) -> String {
        return """
        <ss>0</ss>
        <lang4></lang4>
        <lang11></lang11>
        <lang12></lang12>
        <gameurl4>http://\(serverAddress):18100/cgi-bin/</gameurl4>
        <gameurl11>http://\(serverAddress):18100/cgi-bin/</gameurl11>
        <gameurl12>http://\(serverAddress):18100/cgi-bin/</gameurl12>
        <browserurl4></browserurl4>
        <browserurl11></browserurl11>
        <browserurl12></browserurl12>
        <interval4>\(interval)</interval4>
        <interval11>\(interval)</interval11>
        <interval12>\(interval)</interval12>
        <getWanderingGhostInterval>\(wanderingGhostInterval)</getWanderingGhostInterval>
        <setWanderingGhostInterval>\(wanderingGhostInterval)</setWanderingGhostInterval>
        <getBloodMessageNum>\(bloodMessageNum)</getBloodMessageNum>
        <getReplayListNum>\(replayListNum)</getReplayListNum>
        <enableWanderingGhost>\(enableWanderingGhost)</enableWanderingGhost>
        """
    }
    
    func usResponse(serverAddress: String) -> String {
        return """
        <ss>0</ss>
        <lang1></lang1>
        <lang2></lang2>
        <lang3></lang3>
        <lang5></lang5>
        <lang6></lang6>
        <lang7></lang7>
        <lang8></lang8>
        <gameurl1>http://\(serverAddress):18200/cgi-bin/</gameurl1>
        <gameurl2>http://\(serverAddress):18200/cgi-bin/</gameurl2>
        <gameurl3>http://\(serverAddress):18200/cgi-bin/</gameurl3>
        <browserurl1></browserurl1>
        <browserurl2></browserurl2>
        <browserurl3></browserurl3>
        <interval1>\(interval)</interval1>
        <interval2>\(interval)</interval2>
        <interval3>\(interval)</interval3>
        <getWanderingGhostInterval>\(wanderingGhostInterval)</getWanderingGhostInterval>
        <setWanderingGhostInterval>\(wanderingGhostInterval)</setWanderingGhostInterval>
        <getBloodMessageNum>\(bloodMessageNum)</getBloodMessageNum>
        <getReplayListNum>\(replayListNum)</getReplayListNum>
        <enableWanderingGhost>\(enableWanderingGhost)</enableWanderingGhost>
        """
    }
}
