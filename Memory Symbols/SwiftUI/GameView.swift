import SwiftUI

struct GameView: View {
    var deck: Deck
    
    var body: some View {
        Text(deck.localizedName)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GameView(deck: .weather)
        }
    }
}
