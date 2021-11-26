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
    
    private struct LinkLabelStyle: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.icon
                configuration.title
            }
        }
    }
    
    var body: some View {
        List(Deck.allCases, id: \.id) { deck in
            NavigationLink(destination: LinkDestination(deck: deck, games: games)){
                Label {
                    VStack(alignment: .leading) {
                        Text(deck.localizedName)
                        if games[deck]?.status == .started {
                            Text("DeckSelectionView.PairsLeft.\(games[deck]!.cards.filter({ $0.status != .matched }).count / 2)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                } icon: {
                    Image(systemName: deck.iconName)
                        .foregroundColor(deck.color)
                        .frame(minWidth: 30)
                }
                .frame(minHeight: 60)
                .labelStyle(LinkLabelStyle())
            }
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
