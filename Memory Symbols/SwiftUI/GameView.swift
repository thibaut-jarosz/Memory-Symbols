import SwiftUI

struct GameView: View {
    /// The game
    @State var game: Game
    
    /// The best score before the game started
    @State private var previousBestScore: Int
    
    /// Should present cancel alert
    @State private var isCancelAlertPresented: Bool = false
    
    /// Dismiss action (automatically set when view is pushed)
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Add Score View
            ScoreView(game: $game, bestScore: previousBestScore, restart: restartGame)
                .disabled(game.status != .ended)
                .opacity(game.status == .ended ? 1 : 0)
                .animation(.default, value: game.status)
            
            // Add Board View
            BoardView(game: $game)
                .scaleEffect(game.status == .ended ? 5 : 1)
                .opacity(game.status == .ended ? 0 : 1)
                .animation(.default, value: game)
        }
        .padding(.horizontal)
        
        // Configure navigation bar
        .navigationTitle(game.deck.localizedName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(game.status == .started)
        .toolbar() {
            // Add Cancel button if game is started
            ToolbarItemGroup(placement: .cancellationAction) {
                if game.status == .started {
                    Button(
                        "GameView.Cancel.Button",
                        role: .destructive
                    ) { isCancelAlertPresented.toggle() }
                }
            }
        }
        
        // Add confirmation on cancel
        .alert(
            "GameView.Cancel.Alert.Title",
            isPresented: $isCancelAlertPresented,
            presenting: game.cards.filter{ $0.status != .matched }
        ) { _ in
            Button("GameView.Cancel.Alert.GoBack", role: .cancel) {}
            Button("GameView.Cancel.Alert.Confirm", role: .destructive) {
                dismiss.callAsFunction()
            }
        } message: { cards in
            Text("GameView.Cancel.Alert.Message.\(cards.count)")
        }
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
