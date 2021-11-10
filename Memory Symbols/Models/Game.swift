/// Represents and manage a game
struct Game {
    /// The size of the board
    struct BoardSize {
        /// Number of columns on the board
        let columns: Int
        /// Number of rows on the board
        let rows: Int
        
        /// Number of pairs on the board
        var pairs: Int {
            columns * rows / 2
        }
    }
    
    /// Deck of cards used for the game
    let deck: Deck
    
    /// Size of the board for the game
    let boardSize: BoardSize
    
    /// Cards displayed on the board
    var cards: [Card]
    
    /// Game initializer
    /// - Parameters:
    ///   - deck: deck used for the game
    ///   - boardSize: size of the board for the game
    init(deck: Deck, boardSize: BoardSize = .init(columns: 7, rows: 8)) {
        self.deck = deck
        self.boardSize = boardSize
        
        self.cards = deck.cardNames() // Get names of the cards
            .shuffled() // Shuffle the names so every game is unique
            .prefix(boardSize.pairs) // Keep only the necessary names
            .duplicated() // Duplicate the names so it became card names instead of pair names
            .shuffled() // Shuffle the names
            .map { Card(deck: deck, name: $0, status: .hidden) } // Create the cards
    }
}
