import Foundation

struct Util {
    static func getFileContents(file: String, default otherwise: String?, at path: URL) -> String? {
        let fileManager = FileManager.default
        let url = path.appendingPathComponent(file, isDirectory: false);
        let contents = fileManager.contents(atPath: url.pathComponents.joined(separator: "/"))
        let data = contents ?? otherwise?.data(using: .utf8);
        if(data == nil) {
            return nil;
        }
        let strContents = String(data: data!, encoding: .utf8)
        return strContents
    }
}
