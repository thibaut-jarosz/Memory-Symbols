import SwiftUI

struct DeckSelectionView: View {
    @StateObject var games: GameList = .init()
    
    /// Used to prevent creating a game if link is not opened
    private struct LinkDestination: View {
        let deck: Deck
        @ObservedObject var games: GameList
        
        var body: some View {
            if games[deck] != nil {
                GameView(game: games[deck]!)
            }
            else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .navigationTitle(deck.localizedName)
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear {
                        games[deck] = .init(deck: deck)
                    }
            }
        }
    }
    
    var body: some View {
        List(Deck.allCases, id: \.id) { deck in
            NavigationLink(destination: LinkDestination(deck: deck, games: games)){
                Label {
                    Text(deck.localizedName)
                } icon: {
                    Image(systemName: deck.iconName)
                        .foregroundColor(deck.color)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("DeckSelection.Title")
    }
}

struct DeckSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeckSelectionView()
        }
    }
}
