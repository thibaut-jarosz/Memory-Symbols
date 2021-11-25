import SwiftUI

/// A view representing a board
struct BoardView: View {
    /// The game associated to the board
    @ObservedObject var game: Game
    
    var body: some View {
        VStack( alignment: .leading) {
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
                    CardView(card: card)
                        .onTapGesture {
                            game.reveal(card.wrappedValue)
                        }
                }
            }
            Text("BoardView.score.\(game.score)")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.top)
                .animation(.none, value: game.score)
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    /// An intermediate container, useful for having a fonctionnal state on game
    struct ContainerView: View {
        @State var game: Game
        
        var body: some View {
            ZStack {
                Button("Restart") {
                    withoutAnimation {
                        $game.cards.forEach { $0.wrappedValue.status = .hidden }
                        game.score = 0
                    }
                    game.status = .ready
                    waitForAnimation {
                        game.cards.shuffle()
                    }
                }
                .disabled(game.status != .ended)
                .opacity(game.status == .ended ? 1 : 0)
                .animation(.default, value: game.status)
                
                BoardView(game: game)
                    .scaleEffect(game.status == .ended ? 5 : 1)
                    .opacity(game.status == .ended ? 0 : 1)
                    .animation(.default, value: game.status)
                    .animation(.default, value: game.cards)
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
        .previewLayout(.fixed(width: 300, height: 300))
    }
}
