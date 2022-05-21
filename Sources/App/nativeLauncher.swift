import Foundation

func launchGame(script: String, at cwd: URL) throws {
    let proc = Process()
    proc.executableURL = URL(fileURLWithPath: "/bin/sh")
    let inPipe = Pipe()
    proc.currentDirectoryURL = cwd
    proc.standardInput = inPipe
    try proc.run()
    try inPipe.fileHandleForWriting.write(contentsOf: script.data(using: .utf8)!)
    try inPipe.fileHandleForWriting.synchronize()
    try inPipe.fileHandleForWriting.close()
}