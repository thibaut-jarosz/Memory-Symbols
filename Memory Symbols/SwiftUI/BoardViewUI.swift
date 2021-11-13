import SwiftUI

/// A view representing a board
struct BoardViewUI: View {
    /// The game associated to the board
    @Binding var game: Game
    
    var body: some View {
        // Create grid of cards
        LazyVGrid(columns: .init(
                repeating: .init(
                    .flexible(minimum: 0),
                    spacing: 2 // space between columns
                ),
                count: game.boardSize.columns
            ),
            spacing: 2 // space between rows
        ) {
            ForEach($game.cards) { card in
                CardViewUI(card: card)
                    .onTapGesture {
                        game.reveal(card.wrappedValue)
                    }
            }
        }
    }
}

struct BoardViewUI_Previews: PreviewProvider {
    /// An intermediate container, useful for having a fonctionnal state on game
    struct ContainerView: View {
        @State var game: Game
        
        var body: some View {
            ZStack {
                Button("Restart") {
                    withoutAnimation {
                        $game.cards.forEach { $0.wrappedValue.status = .hidden }
                    }
                    game.status = .ready
                    waitForAnimation {
                        game.cards.shuffle()
                    }
                }
                .disabled(game.status != .ended)
                .opacity(game.status == .ended ? 1 : 0)
                .animation(.default, value: game.status)
                
                BoardViewUI(game: $game)
                    .scaleEffect(game.status == .ended ? 5 : 1)
                    .opacity(game.status == .ended ? 0 : 1)
                    .animation(.default, value: game)
            }
        }
    }
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            ContainerView(game: Game(
                deck: .weather,
                boardSize: .init(columns: 3, rows: 2)
            ))
            .preferredColorScheme($0)
        }
        .padding()
        .previewLayout(.fixed(width: 300, height: 200))
    }
}
