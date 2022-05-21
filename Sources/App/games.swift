import Foundation

struct Game: Encodable {
    let name: String
    let path: String
    let description: String
    let nativeLauncher: String?
}

func getFileContents(file: String, default otherwise: String?, at path: URL) -> String? {
    let fileManager = FileManager.default
    let url = path.appendingPathComponent(file, isDirectory: false);
    let contents = fileManager.contents(atPath: url.pathComponents.joined(separator: "/"))
    print(contents as Any)
    let data = contents ?? otherwise?.data(using: .utf8);
    if(data == nil) {
        return nil;
    }
    let strContents = String(data: data!, encoding: .utf8)
    return strContents
}

func gameInfo(at url: URL) -> Game {
    Game(
        name: getFileContents(file: "name", default: url.lastPathComponent, at: url)!,
        path: getFileContents(file: "path", default: "/games/" + url.lastPathComponent, at: url)!,
        description: getFileContents(file: "description", default: "", at: url)!,
        nativeLauncher: getFileContents(file: "native-launcher", default: nil, at: url)
    )
}

func gameUrl(name: String) -> URL {
    let fileManager = FileManager.default
    let gamesPath = URL(string: fileManager.currentDirectoryPath + "/")?.appendingPathComponent("games")
    return gamesPath!.appendingPathComponent(name)
}

func getGames() throws -> [Game] {
    let fileManager = FileManager.default
    let gamesPath = URL(string: "games", relativeTo: URL(string: fileManager.currentDirectoryPath + "/"))!
    let fileURLs = try fileManager.contentsOfDirectory(at: gamesPath, includingPropertiesForKeys: nil)
    return fileURLs.map { url in
        print(url)
        return gameInfo(at: url)
    }
}
