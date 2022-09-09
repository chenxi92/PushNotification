//
//  File.swift
//  
//
//  Created by peak on 2022/7/29.
//
/// Copy from JohnSundell/ShellOut
/// https://github.com/JohnSundell/ShellOut/blob/master/Sources/ShellOut.swift
import Foundation

// MARK: API

@discardableResult
public func ExecuteCommands(
    commands: [String],
    at path: String = ".",
    process: Process = .init(),
    outputHandle: FileHandle? = nil,
    errorHandle: FileHandle? = nil
) throws -> String {
    let command = commands.joined(separator: " && ")
    return try ExecuteCommand(
        command: command,
        at: path,
        process: process,
        outputHandle: outputHandle,
        errorHandle: errorHandle
    )
}

@discardableResult
public func ExecuteCommand(
    command: String,
    arguments: [String] = [],
    at path: String = ".",
    process: Process = .init(),
    outputHandle: FileHandle? = nil,
    errorHandle: FileHandle? = nil
) throws -> String {
    let command = "cd \(path) && \(command) \(arguments.joined(separator: " "))"

    return try process.executeBash(
        with: command,
        outputHandle: outputHandle,
        errorHandle: errorHandle
    )
}

// MARK: Implementation

private extension Process {
    @discardableResult
    func executeBash(with command: String, outputHandle: FileHandle? = nil, errorHandle: FileHandle? = nil) throws -> String {
        launchPath = "/bin/bash"
        arguments = ["-c", command]
        
        let outputQueue = DispatchQueue(label: "base-output-queue")
        
        var outputData = Data()
        var errorData = Data()
        
        let outputPipe = Pipe()
        standardOutput = outputPipe
        
        let errorPipe = Pipe()
        standardError = errorPipe
        
        outputPipe.fileHandleForReading.readabilityHandler = { handler in
            let data = handler.availableData
            outputQueue.async {
                outputData.append(data)
                outputHandle?.write(data)
            }
        }
        
        errorPipe.fileHandleForReading.readabilityHandler = { handler in
            let data = handler.availableData
            outputQueue.async {
                errorData.append(data)
                errorHandle?.write(data)
            }
        }
        
        launch()
        
        waitUntilExit()
        
        if let handle = outputHandle, !handle.isStandard {
            handle.closeFile()
        }
        
        if let handle = errorHandle, !handle.isStandard {
            handle.closeFile()
        }
        
        outputPipe.fileHandleForReading.readabilityHandler = nil
        errorPipe.fileHandleForReading.readabilityHandler = nil
        
        return try outputQueue.sync {
            if terminationStatus != 0 {
                throw ShellError(terminationStatus: terminationStatus, errorData: errorData, outputData: outputData)
            }
            return outputData.shellOutput()
        }
    }
}

public struct ShellError: Swift.Error {
    public let terminationStatus: Int32
    public let errorData: Data
    public let outputData: Data
    public var message: String { errorData.shellOutput() }
    public var output: String { outputData.shellOutput() }
}

private extension FileHandle {
    var isStandard: Bool {
        return self === FileHandle.standardOutput ||
               self === FileHandle.standardError ||
               self === FileHandle.standardInput
    }
}

private extension Data {
    func shellOutput() -> String {
        guard let output = String(data: self, encoding: .utf8) else {
            return ""
        }
        
        guard !output.hasPrefix("\n") else {
            let endIndex = output.index(before: output.endIndex)
            return String(output[..<endIndex])
        }
        
        return output
    }
}

