import Combine

/// Manage a list of ongoing games
class GameList: ObservableObject {
    /// The list of games, publicly available via subscript
    @Published private var games: [Deck:Game] = [:]
    
    /// Subscript to access the games
    subscript(deck: Deck) -> Game? {
        get {
            games[deck]
        }
        set {
            games[deck] = newValue
        }
    }
}
