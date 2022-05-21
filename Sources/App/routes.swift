import Vapor
import NIOCore

struct LauncherContext: Encodable {
    let games: [Game]
}

func routes(_ app: Application) throws {
    app.get { req in
        req.view.render("launcher", LauncherContext(games: try getGames()))
    }

    app.get("games", ":name") { req -> EventLoopFuture<Response> in
        let url = gameUrl(name: req.parameters.get("name")!)
        print(url)
        let game = gameInfo(at: url)
        print(game)
        if(game.nativeLauncher != nil) {
            print(game.nativeLauncher as Any)
            do {
                try launchGame(script: game.nativeLauncher!, at: url)
            } catch let e {
                print(e)
            }
            return req.eventLoop.makeSucceededFuture(req.redirect(to: "/"))
        }
        else {
            return req.eventLoop.makeSucceededFuture(
                req.fileio.streamFile(at: "games/" + req.parameters.get("name")! + "/index.html")
            )
        }
    }

    app.get("games", ":name", "**") { req in
        req.eventLoop.makeSucceededFuture(
            req.fileio.streamFile(at: "games/" + req.parameters.get("name")! + "/" + req.parameters.getCatchall().joined(separator: "/"))
        )
    }
}
