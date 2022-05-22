import Foundation

protocol NativeLauncher {
    func launch() throws
}

extension Game : NativeLauncher {
    func launch() throws {
        if(nativeLauncher == nil) {
            return
        }
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/bin/sh")
        let inPipe = Pipe()
        proc.currentDirectoryURL = localPath
        proc.standardInput = inPipe
        try proc.run()
        try inPipe.fileHandleForWriting.write(contentsOf: (nativeLauncher?.data(using: .utf8))!)
        try inPipe.fileHandleForWriting.synchronize()
        try inPipe.fileHandleForWriting.close()
    }
}
