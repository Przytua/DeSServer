//
//  FileLogger.swift
//  DeSServerPackageDescription
//
//  Created by Łukasz Przytuła on 29.11.2017.
//

import Foundation

/// Logs to the file
public final class FileLogger: LogProtocol {
    public var enabled: [LogLevel] = LogLevel.all
    
    let fileName = "logs.txt"
    let fileHandle: FileHandle
    
    let endlineData = "\n".data(using: .utf8)!
    
    public init?() {
        let fileURL = URL(fileURLWithPath: fileName)
        print("Log file: \(fileURL)\n")
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        }
        
        if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
            self.fileHandle = fileHandle
            append(string: "Session started: \(Date())")
        } else {
            print("Can't open file handle\n")
            return nil
        }
    }
    
    /// The basic log function of the console.
    public func log(
        _ level: LogLevel,
        message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
        ) {
        if enabled.contains(level) {
            append(string: message)
        }
    }
    
    func append(string: String) {
        fileHandle.seekToEndOfFile()
        if let data = string.data(using: .utf8) {
            fileHandle.write(data)
            fileHandle.write(endlineData)
        }
    }
}
