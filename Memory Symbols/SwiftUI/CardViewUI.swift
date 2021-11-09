import SwiftUI

struct CardViewUI: View, Animatable {
    @Binding var card: Card
    
    var body: some View {
        GeometryReader() { geometryProxy in
            ZStack.init(content: {
                
                // Card background
                Rectangle()
                    .foregroundColor(card.deck.color)
                    .aspectRatio(1, contentMode: .fit)
                    .opacity(card.status == .matched ? 0.5 : 1)
                
                // Card Image
                if card.status != .hidden {
                    Image(systemName: card.name)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: geometryProxy.size.width*0.7,
                            height: geometryProxy.size.height*0.7,
                            alignment: .center
                        )
                        .foregroundColor(Color(
                            uiColor: .systemBackground
                        ))
                        .opacity(card.status == .hidden ? 0 : 1)
                }
            })
        }
        .aspectRatio(1, contentMode: .fit)
        .rotation3DEffect(
            Angle(degrees: card.status == .hidden ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            anchor: UnitPoint.center,
            anchorZ: 0,
            perspective: 0.5
        )
        .animation(.default, value: card)
    }
}

struct CardViewUI_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            ForEach(Card.Status.allCases, id: \.hashValue) { status in
                VStack {
                    CardViewUI(card: .constant(Card(
                        deck: .weather,
                        name: Deck.weather.iconName,
                        status: status
                    )))
                }
                .padding()
            }
            .previewLayout(.fixed(width: 100, height: 100))
            .preferredColorScheme($0)
        }
    }
}
