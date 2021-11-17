import SwiftUI

struct DeckSelectionView: View {
    @State var games: [Deck:Game] = [:]
    
    /// Used to prevent creating a game if link is not opened
    private struct LinkDestination: View {
        let deck: Deck
        @Binding var games: [Deck:Game]
        
        var body: some View {
            // If we let `toNonOptional` handle the game creation,
            // it will create multiple games and be saved into `games`
            // only after first card had been tapped.
            if games[deck] != nil {
                GameView(
                    game: $games[deck].toNonOptional {
                        // Should never be called, but just in case...
                        .init(deck: deck)
                    }
                ).onDisappear {
                    // Temporary code, here only to prevent breaking the `GameView` interface
                    games[deck] = nil
                }
            }
            else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .onAppear {
                        games[deck] = .init(deck: deck)
                    }
            }
        }
    }
    
    var body: some View {
        List(Deck.allCases, id: \.id) { deck in
            NavigationLink(destination: LinkDestination(deck: deck, games: $games)){
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
