import Vapor
import NIOCore

struct LauncherContext: Encodable {
    let games: [Game]
}

func routes(_ app: Application) throws {
    app.get { req in
        req.view.render("launcher", LauncherContext(games: try Game.all()))
    }

    app.get("games", ":name") { req -> EventLoopFuture<Response> in
        let url = Game.url(of: req.parameters.get("name")!)
        let game = Game(at: url)
        if(game.nativeLauncher != nil) {
            do {
                try game.launch()
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
