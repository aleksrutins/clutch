import Foundation

struct Game: Encodable {
    let name: String
    let path: String
    let description: String
}

func getFileContents(file: String, default value: String, at path: URL) -> String {
    let fileManager = FileManager.default
    let url = path.appendingPathComponent(file, isDirectory: false);
    let contents = fileManager.contents(atPath: url.pathComponents.joined(separator: "/"))
    let strContents = String(data: (contents ?? value.data(using: .utf8)!), encoding: .utf8)!
    return strContents
}

func gameInfo(at url: URL) -> Game {
    Game(
        name: getFileContents(file: "name", default: url.lastPathComponent, at: url),
        path: getFileContents(file: "path", default: "/games/" + url.lastPathComponent, at: url),
        description: getFileContents(file: "description", default: "", at: url)
    )
}

func getGames() throws -> [Game] {
    let fileManager = FileManager.default
    let gamesPath = URL(string: "games", relativeTo: URL(string: fileManager.currentDirectoryPath + "/"))!
    let fileURLs = try fileManager.contentsOfDirectory(at: gamesPath, includingPropertiesForKeys: nil)
    return fileURLs.map { url in
        gameInfo(at: url)
    }
}
