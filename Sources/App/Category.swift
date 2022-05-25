struct Category : Encodable {
    let name: String
    let games: [Game]
    static func sort(games: [Game]) -> [Category] {
        return games.reduce([]) { current, game in
            guard let preexistingCategory = current.firstIndex(where: {elem in elem.name == game.category}) else {
                return current + [Category(name: game.category, games: [game])]
            }
            var new = current
            new[preexistingCategory] = current[preexistingCategory].withGame(game: game)
            return new
        }.map { (category: Category) in category.sorted() }.sorted { $0.name < $1.name }
    }
    func withGame(game: Game) -> Category {
        Category(name: name, games: games + [game])
    }
    func sorted() -> Category {
        Category(name: name, games: games.sorted {$0.name < $1.name})
    }
}
