import SwiftUI

/// A view representing a single card
struct CardView: View, Animatable {
    
    /// Card associated to the view
    @Binding var card: Card
    
    /// A view modifier that do all the work.
    /// It is required by rotation animation, so the image only appears or disappears below or above 90º
    private struct RotatingCard: Animatable, ViewModifier {
        
        /// Card associated to the view modifier
        @Binding var card: Card
        
        /// The rotation angle of card flip animation
        private var angle: Double
        
        // Animated data required by `Animatable`
        var animatableData: Double {
            get { angle }
            set { angle = newValue }
        }
        
        /// Initializer of the view modifier
        /// - Parameter card: the card associated to the view modifier
        init(card: Binding<Card>) {
            _card = card
            angle = card.wrappedValue.status == .hidden ? 180 : 0
        }
        
        /// The ViewModifier function that will do all the work of creating the view
        /// - Parameter content: original view content, ignored by this function.
        /// - Returns: The animatable card view
        func body(content: Content) -> some View {
            
            // Use geometry reader to constrain image size
            GeometryReader() { geometryProxy in
                ZStack {
                    // Add card background
                    Rectangle()
                        .foregroundColor(card.deck.color)
                        .aspectRatio(1, contentMode: .fit)
                        .opacity(card.status == .matched ? 0.5 : 1)
                    
                    // Add card image, only if card is visible
                    if angle < 90 {
                        Image(systemName: card.name)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(uiColor: .systemBackground))
                            .frame(
                                width: geometryProxy.size.width*0.7,
                                height: geometryProxy.size.height*0.7,
                                alignment: .center
                            )
                    }
                }
                // Apply card rotation effect
                .rotation3DEffect(
                    .degrees(angle),
                    axis: (0, 1, 0),
                    perspective: 0.5
                )
            }
            // Make card a square
            .aspectRatio(1, contentMode: .fit)
        }
    }
    
    /// Main view body
    var body: some View {
        // Group is ignored
        Group { }
            // Replace Group by the real card content
            .modifier(RotatingCard(card: $card))
            // Make the card animatable
            .animation(.default, value: card)
    }
}

struct CardView_Previews: PreviewProvider {
    /// An intermediate container, useful for having a fonctionnal state on card and for managing tap gesture
    struct ContainerView: View {
        @State var card: Card
        
        var body: some View {
            CardView(card: $card).onTapGesture {
                switch card.status {
                case .hidden:
                    card.status = .revealed
                case .revealed:
                    card.status = .hidden
                case .matched:
                    break
                }
            }
        }
    }
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(Card.Status.allCases, id: \.hashValue) { status in
                VStack {
                    ContainerView(card: .init(
                        deck: .weather,
                        name: Deck.weather.iconName,
                        status: status
                    ))
                }
                .padding()
                .previewDisplayName("\(colorScheme) \(status)")
            }
            .previewLayout(.fixed(width: 100, height: 100))
            .preferredColorScheme(colorScheme)
        }
    }
}
