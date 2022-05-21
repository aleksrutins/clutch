import Foundation

func launchGame(script: String, at cwd: URL) throws {
    let proc = Process()
    proc.executableURL = URL(fileURLWithPath: "///bin/sh")
    print(proc.executableURL as Any)
    proc.currentDirectoryURL = cwd
    proc.standardInput = script
    //try proc.run()
}