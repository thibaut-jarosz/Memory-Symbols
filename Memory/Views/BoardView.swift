import UIKit

/// Delegate of BoardView
protocol BoardViewDelegate: AnyObject {
    
    /// Get the number of columns that should be displayed
    func numberOfColumns(in boardView: BoardView) -> Int
    /// Called when a card is touched
    func boardView(_ boardView: BoardView, touchesBeganOn cardView: CardView)
}

/// A view that store all game cards
class BoardView: UIView {
    /// Delegate of the BoardView
    weak var delegate: BoardViewDelegate?
    
    /// List of CardView
    var cardViews: [CardView] = [] {
        didSet {
            cardViews.forEach { cardView in
                cardView.delegate = self
                addSubview(cardView)
            }
            updateCardsLayoutContraints()
        }
    }
    
    /// All constraints that manage CardViews position
    var cardsLayoutContraints: [NSLayoutConstraint] = []
}

// MARK: - Layout
private extension BoardView {
    func updateCardsLayoutContraints() {
        translatesAutoresizingMaskIntoConstraints = false
        removeConstraints(cardsLayoutContraints)
        cardsLayoutContraints = []
        
        guard let firstCardView = cardViews.first else { return }
        
        var constraints: [NSLayoutConstraint] = []
        let spaceBetweenCards = CGFloat(2)
        let nbColumns = delegate?.numberOfColumns(in: self) ?? 9
        var previousCardView = firstCardView
        
        constraints.append(contentsOf: [
            // Align first card top to top of superview
            firstCardView.topAnchor.constraint(equalTo: topAnchor),
            
            // Align last card bottom to bottom of superview
            cardViews[cardViews.count-1].bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        
        for (index, cardView) in cardViews.enumerated() {
            let column: Int = index%nbColumns
            
            switch column {
            
            case 0: // First card in column
                constraints.append(
                    // Align leading with superview
                    cardView.leadingAnchor.constraint(equalTo: leadingAnchor)
                )
                let row: Int = index/nbColumns
                
                if row != 0 { // Not first card but still first in column
                    constraints.append(
                        // Constrain top to bottom of previous view
                        cardView.topAnchor.constraint(equalTo: previousCardView.bottomAnchor, constant: spaceBetweenCards)
                    )
                }
                
            case nbColumns-1: // Last card in column
                constraints.append(
                    // Align trailing with superview
                    cardView.trailingAnchor.constraint(equalTo: trailingAnchor)
                )
                // Also apply default constraints
                fallthrough
                
            default:
                constraints.append(contentsOf: [
                    // Set leading after trailing of previous card
                    cardView.leadingAnchor.constraint(equalTo: previousCardView.trailingAnchor, constant: spaceBetweenCards),
                    
                    // Align top with top of previous card
                    cardView.topAnchor.constraint(equalTo: previousCardView.topAnchor),
                
                    // Make cards same height
                    cardView.heightAnchor.constraint(equalTo: previousCardView.heightAnchor)
                ])
            }
            
            previousCardView = cardView
        }
        
        cardsLayoutContraints = constraints
        addConstraints(cardsLayoutContraints)
    }
}

// MARK: - CardViewDelegate
extension BoardView: CardViewDelegate {
    
    /// Manage action when card has been touched
    /// - Parameter cardView: the touched card
    func touchesBegan(on cardView: CardView) {
        // Just forward to delegate
        delegate?.boardView(self, touchesBeganOn: cardView)
    }
}
