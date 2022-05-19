import Foundation

struct Game: Encodable {
    let name: String
    let path: String
}

func gameInfo(at url: URL) -> Game {
    let fileManager = FileManager.default
    let nameURL = url.appendingPathComponent("name", isDirectory: false);
    let pathURL = url.appendingPathComponent("path", isDirectory: false);
    let name = fileManager.contents(atPath: nameURL.pathComponents.joined(separator: "/"))
    let strName = String(data: (name ?? url.lastPathComponent.data(using: .utf8)!), encoding: .utf8)!
    let path = fileManager.contents(atPath: pathURL.pathComponents.joined(separator: "/"))
    let strPath = String(data: (path ?? ("/games/" + url.lastPathComponent).data(using: .utf8)!), encoding: .utf8)!
    return Game(name: strName, path: strPath)
}

func getGames() throws -> [Game] {
    let fileManager = FileManager.default
    let gamesPath = URL(string: "games", relativeTo: URL(string: fileManager.currentDirectoryPath + "/"))!
    let fileURLs = try fileManager.contentsOfDirectory(at: gamesPath, includingPropertiesForKeys: nil)
    return fileURLs.map { url in
        gameInfo(at: url)
    }
}