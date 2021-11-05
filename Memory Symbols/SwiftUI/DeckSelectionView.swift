import SwiftUI

struct DeckSelectionView: View {
    var body: some View {
        List(Deck.allCases, id: \.id) { deck in
            NavigationLink(destination: GameView(deck: deck)){
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
