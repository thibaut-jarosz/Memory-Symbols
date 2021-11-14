import SwiftUI

struct GameView: View {
    /// The game
    @State var game: Game
    
    /// The best score before the game started
    @State private var previousBestScore: Int
    
    /// Dismiss action (automatically set when view is pushed)
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ScoreViewUI(game: $game, bestScore: previousBestScore, restart: restartGame)
                .disabled(game.status != .ended)
                .opacity(game.status == .ended ? 1 : 0)
                .animation(.default, value: game.status)
            
            BoardViewUI(game: $game)
                .scaleEffect(game.status == .ended ? 5 : 1)
                .opacity(game.status == .ended ? 0 : 1)
                .animation(.default, value: game)
        }
        .padding(.horizontal)
        .navigationTitle(game.deck.localizedName)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    /// Restart the game
    func restartGame() {
        // Hide all cards (without animation
        withoutAnimation {
            $game.cards.forEach { $0.wrappedValue.status = .hidden }
        }
        
        // Set game ready to hide score and show board
        game.status = .ready
        
        // Wait for previous animation to finish
        waitForAnimation {
            // Update scores and shuffle cards
            previousBestScore = game.deck.bestScore
            game.score = 0
            game.cards.shuffle()
        }
    }
}

extension GameView {
    init(game: Game) {
        self.init(game: game, previousBestScore: game.deck.bestScore)
    }
    
    init(deck: Deck) {
        self.init(game: .init(deck: deck), previousBestScore: deck.bestScore)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            NavigationView {
                GameView(game: .init(
                    deck: .weather,
                    boardSize: .init(columns: 3, rows: 2)
                ))
            }
            .preferredColorScheme($0)
        }
    }
}
