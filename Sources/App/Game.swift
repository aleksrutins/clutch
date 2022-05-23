import Foundation

struct Game: Encodable {
    let name: String
    let path: String
    let localPath: URL
    let description: String
    let category: String
    let nativeLauncher: String?
    init(at url: URL) {
        localPath = url
        name = Util.getFileContents(file: "name", default: url.lastPathComponent, at: url)!
        path = Util.getFileContents(file: "path", default: "/games/" + url.lastPathComponent, at: url)!
        description = Util.getFileContents(file: "description", default: "", at: url)!
        nativeLauncher = Util.getFileContents(file: "native-launcher", default: nil, at: url)
        category = Util.getFileContents(file: "category", default: "Misc", at: url)!
    }
    static func all() throws -> [Game] {
        let fileManager = FileManager.default
        let gamesPath = URL(string: "games", relativeTo: URL(string: fileManager.currentDirectoryPath + "/"))!
        let fileURLs = try fileManager.contentsOfDirectory(at: gamesPath, includingPropertiesForKeys: nil)
        return fileURLs.map { url in
            return Game(at: url)
        }
    }
    static func allSorted() throws -> [Category] {
        try Category.sort(games: all())
    }
    static func url(of name: String) -> URL {
        let fileManager = FileManager.default
        let gamesPath = URL(string: "file://" + fileManager.currentDirectoryPath + "/")?.appendingPathComponent("games")
        return gamesPath!.appendingPathComponent(name)
    }
}
