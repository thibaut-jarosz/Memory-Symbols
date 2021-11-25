import Combine

/// Manage a list of ongoing games
class GameList: ObservableObject {
    /// The list of games, publicly available via subscript
    @Published private var games: [Deck:Game] = [:]
    
    /// List of cancellable sinks
    private var cancellables: [Deck:AnyCancellable] = [:]
    
    /// Subscript to access the games
    subscript(deck: Deck) -> Game? {
        get {
            games[deck]
        }
        set {
            games[deck] = newValue
            cancellables[deck]?.cancel()
            
            if let newValue = newValue {
                cancellables[deck] = newValue.objectWillChange.sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
            }
        }
    }
}
