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
            }
        }
    }
}

struct BoardViewUI_Previews: PreviewProvider {
    /// An intermediate container, useful for having a fonctionnal state on game
    struct ContainerView: View {
        @State var game: Game
        
        var body: some View {
            BoardViewUI(game: $game)
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
