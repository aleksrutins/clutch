import Vapor

struct LauncherContext: Encodable {
    let games: [Game]
}

func routes(_ app: Application) throws {
    app.get { req in
        req.view.render("launcher", LauncherContext(games: try getGames()))
    }

    app.get("games", ":name") { req in
        req.eventLoop.makeSucceededFuture(
            req.fileio.streamFile(at: "games/" + req.parameters.get("name")! + "/index.html")
        )
    }

    app.get("games", ":name", "**") { req in
        req.eventLoop.makeSucceededFuture(
            req.fileio.streamFile(at: "games/" + req.parameters.get("name")! + "/" + req.parameters.getCatchall().joined(separator: "/"))
        )
    }
}
