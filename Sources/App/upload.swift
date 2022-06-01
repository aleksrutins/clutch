import Vapor
import Zip

func upload(req: Request) throws -> Response {
    struct Input : Content {
        var name: String
        var description: String
        var file: File?
        var submission: String
        var url: String?
        var category: String
        var cmd: String?
    }
    
    let input = try req.content.decode(Input.self)
    let path = Game.url(of: input.name)
    try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)

    if(input.submission == "files" || input.submission == "native") {
        let zipfilePath = path.appendingPathExtension("zip")
        if FileManager.default.createFile(atPath: (zipfilePath as NSURL).resourceSpecifier!.decodeUrl()!, contents: Data(buffer: input.file!.data)) {
            try Zip.unzipFile(zipfilePath, destination: path, overwrite: true, password: nil)
        } else {
            print("Failed to write zipfile")
        }
        FileManager.default.createFile(atPath: path.appendingPathComponent("description").absoluteString.decodeUrl()!, contents: input.description.data(using: .utf8))
        FileManager.default.createFile(atPath: path.appendingPathComponent("category").absoluteString.decodeUrl()!, contents: input.category.data(using: .utf8))
        if(input.cmd != nil) {
            FileManager.default.createFile(atPath: path.appendingPathComponent("native-launcher").absoluteString.decodeUrl()!, contents: input.cmd!.data(using: .utf8))
        }
        return req.redirect(to: "/")
    } else {
        FileManager.default.createFile(atPath: path.appendingPathComponent("url").absoluteString.decodeUrl()!, contents: input.url!.data(using: .utf8))
        FileManager.default.createFile(atPath: path.appendingPathComponent("description").absoluteString.decodeUrl()!, contents: input.description.data(using: .utf8))
        FileManager.default.createFile(atPath: path.appendingPathComponent("category").absoluteString.decodeUrl()!, contents: input.category.data(using: .utf8))
        return req.redirect(to: "/")
    }
}
