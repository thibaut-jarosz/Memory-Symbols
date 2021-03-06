import SwiftUI

struct ScoreView: View {
    @ObservedObject var game: Game
    let bestScore: Int
    var restart: () -> Void
    
    var body: some View {
        VStack {
            Text("ScoreView.Title")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            Text(AttributedString(
                localizedMarkdown: "ScoreView.Current.\(game.score)")
            )
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .animation(.none, value: game.score)
            
            Text(
                bestScore > game.score ?
                "ScoreView.Best.Previous.\(bestScore)" :
                "ScoreView.Best.Current.\(bestScore != 0 ? bestScore : game.score)"
            )
                .font(.headline)
                .padding(.vertical)
                .animation(.none, value: game.score)
            
            Button("ScoreView.Restart", action: restart)
                .padding(.vertical)
                .buttonStyle(.borderedProminent)
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ScoreView(
                game: {
                    let game = Game(deck: .weather)
                    game.score = .random(in: 0...1000)
                    return game
                }(),
                bestScore: .random(in: 0...1000),
                restart: {}
            )
                .previewLayout(.fixed(width: 300, height: 400))
                .preferredColorScheme(colorScheme)
        }
    }
}
