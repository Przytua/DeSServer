//
//  SoulsServerConfiguration.swift
//  DeSServerPackageDescription
//
//  Created by Łukasz Przytuła on 30.11.2017.
//

import Foundation

class SoulsServerConfiguration {
    
    static let euServerAddress = "http://ds-eu-g.scej-online.jp:18666"
    static let jpServerAddress = "http://demons-souls.scej-online.jp:18666"
    static let usServerAddress = "http://g.demons-souls.com:18666"
    
    static let serverAddress = "46.101.126.61"
    
    static let euResponse = """
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
    <interval2>120</interval2>
    <interval5>120</interval5>
    <interval6>120</interval6>
    <interval7>120</interval7>
    <interval8>120</interval8>
    <getWanderingGhostInterval>20</getWanderingGhostInterval>
    <setWanderingGhostInterval>20</setWanderingGhostInterval>
    <getBloodMessageNum>80</getBloodMessageNum>
    <getReplayListNum>80</getReplayListNum>
    <enableWanderingGhost>1</enableWanderingGhost>
    """
    static let euData = (euResponse).data(using: String.Encoding.utf8)
    static let euBase64Response = euData!.base64EncodedString(options: .lineLength64Characters)
    
    static let jpResponse = """
    <ss>0</ss>
    <lang4></lang4>
    <lang11></lang11>
    <lang12></lang12>
    <gameurl4>http://\(serverAddress):18001/cgi-bin/</gameurl4>
    <gameurl11>http://\(serverAddress):18001/cgi-bin/</gameurl11>
    <gameurl12>http://\(serverAddress):18001/cgi-bin/</gameurl12>
    <browserurl4></browserurl4>
    <browserurl11></browserurl11>
    <browserurl12></browserurl12>
    <interval4>120</interval4>
    <interval11>120</interval11>
    <interval12>120</interval12>
    <getWanderingGhostInterval>20</getWanderingGhostInterval>
    <setWanderingGhostInterval>20</setWanderingGhostInterval>
    <getBloodMessageNum>80</getBloodMessageNum>
    <getReplayListNum>80</getReplayListNum>
    <enableWanderingGhost>1</enableWanderingGhost>
    """
    static let jpData = (euResponse).data(using: String.Encoding.utf8)
    static let jpBase64Response = euData!.base64EncodedString(options: .lineLength64Characters)
    
    static let usResponse = """
    <ss>0</ss>
    <lang1></lang1>
    <lang2></lang2>
    <lang3></lang3>
    <lang5></lang5>
    <lang6></lang6>
    <lang7></lang7>
    <lang8></lang8>
    <gameurl1>http://\(serverAddress):18002/cgi-bin/</gameurl1>
    <gameurl2></gameurl2>
    <gameurl3></gameurl3>
    <browserurl1></browserurl1>
    <browserurl2></browserurl2>
    <browserurl3></browserurl3>
    <interval1>120</interval1>
    <interval2></interval2>
    <interval3></interval3>
    <getWanderingGhostInterval>40</getWanderingGhostInterval>
    <setWanderingGhostInterval>40</setWanderingGhostInterval>
    <getBloodMessageNum>60</getBloodMessageNum>
    <getReplayListNum>60</getReplayListNum>
    <enableWanderingGhost>1</enableWanderingGhost>
    """
    static let usData = (euResponse).data(using: String.Encoding.utf8)
    static let usBase64Response = euData!.base64EncodedString(options: .lineLength64Characters)

//    func getWiFiAddress() -> String? {
//
//        var address : String?
//
//        // Get list of all interfaces on the local machine:
//        var ifaddr : UnsafeMutablePointer<ifaddrs>?
//        guard getifaddrs(&ifaddr) == 0 else { return nil }
//        guard let firstAddr = ifaddr else { return nil }
//
//        // For each interface ...
//        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
//            let interface = ifptr.pointee
//
//            // Check for IPv4 or IPv6 interface:
//            let addrFamily = interface.ifa_addr.pointee.sa_family
//            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//
//                // Check interface name:
//                let name = String(cString: interface.ifa_name)
//                if  name == "en0" {
//
//                    // Convert interface address to a human readable string:
//                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
//                                &hostname, socklen_t(hostname.count),
//                                nil, socklen_t(0), NI_NUMERICHOST)
//                    address = String(cString: hostname)
//                }
//            }
//        }
//        freeifaddrs(ifaddr)
//
//        return address
//    }
}
