import UIKit

/// Delegate of CardsContainerViewController
protocol CardsContainerViewControllerDelegate: AnyObject {
    /// Called when game did end because all cards are revealed
    func gameDidEnd(_ cardContainer: CardsContainerViewController)
}


/// A controller that manage all game cards
class CardsContainerViewController: UIViewController {
    /// Delegate of the CardsContainerViewController
    weak var delegate: CardsContainerViewControllerDelegate?
    
    /// Game score (lower is better)
    var score: Int = 0
    
    /// A set of cards
    var cardSet: CardSet?
    
    /// List of CardView
    var cardViews: [CardView] = []
    
    /// All constraints that manage CardViews position
    var cardLayoutContraints: [NSLayoutConstraint] = []
}


// MARK: - View Loading
extension CardsContainerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Create all CardViews
        cardViews = cardSet?.generateCards().shuffled().compactMap(CardView.init(card:)) ?? []
        
        // Configure CardViews
        cardViews.forEach { cardView in
            cardView.delegate = self
            view.addSubview(cardView)
        }
        
        // update layout
        updateCardViewsContraints(animated: false)
        self.view.transform = .init(scaleX: 0, y: 0)
        self.view.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.transition(with: view, duration: 0.5) {
            self.view.transform = .init(scaleX: 1, y: 1)
            self.view.alpha = 1
        }
    }
}


// MARK: - Cards management
extension CardsContainerViewController {
    /// Update CardViews positions as grid
    private func updateCardViewsContraints(animated: Bool) {
        view.removeConstraints(cardLayoutContraints)
        cardLayoutContraints = constraintsForGrid()
        view.addConstraints(cardLayoutContraints)
        
        if animated {
            UIView.transition(with: view, duration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    /// Shuffle the cards
    func shuffleCards() {
        cardViews = cardViews.shuffled()
        updateCardViewsContraints(animated: true)
    }
    
    /// Hide all the cards
    func hideAllCards() {
        for cardView in cardViews {
            cardView.setStatusAnimated(.hidden)
        }
    }
    
    /// Restart the game by moving back all cards
    func restartGame() {
        score = 0
        self.view.transform = .init(scaleX: 1, y: 1)
        self.view.alpha = 1
    }
    
    /// Move away all cards
    func moveCardsAway() {
        self.view.transform = .init(scaleX: 5, y: 5)
        self.view.alpha = 0
    }
}

// MARK: - Constraints
extension CardsContainerViewController {
    private func constraintsForGrid() -> [NSLayoutConstraint] {
        guard let firstCardView = cardViews.first else { return [] }
        
        var constraints: [NSLayoutConstraint] = []
        let spaceBetweenCards = CGFloat(2)
        var previousCardView = firstCardView
        
        constraints.append(contentsOf: [
            // Align first card top to top of superview
            firstCardView.topAnchor.constraint(equalTo: view.topAnchor),
            
            // Align last card bottom to bottom of superview
            cardViews[cardViews.count-1].bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        for (index, cardView) in cardViews.enumerated() {
            let column: Int = index%9
            
            switch column {
            
            case 0: // First card in column
                constraints.append(
                    // Align leading with superview
                    cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
                )
                let row: Int = index/9
                
                if row != 0 { // Not first card but still first in column
                    constraints.append(
                        // Constrain top to bottom of previous view
                        cardView.topAnchor.constraint(equalTo: previousCardView.bottomAnchor, constant: spaceBetweenCards)
                    )
                }
                
            case 8: // Last card in column
                constraints.append(
                    // Align trailing with superview
                    cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
        
        return constraints
    }
}


// MARK: - CardViewDelegate
extension CardsContainerViewController: CardViewDelegate {
    
    /// Manage action when card has been touched
    /// - Parameter cardView: the touched card
    func touchesBegan(on cardView: CardView) {
        // Check if card was hidden
        guard cardView.card.status == .hidden else { return }
        
        let alreadyRevealedCards = cardViews.filter { $0.card.status == .revealed }
        
        // Increase score and reveal card
        score += 1
        cardView.setStatusAnimated(.revealed)
        
        // If only 1 card was revealed before touching the card
        if alreadyRevealedCards.count == 1, let alreadyRevealedCardView = alreadyRevealedCards.first {
            
            // If card is matching
            if cardView.card.name == alreadyRevealedCardView.card.name {
                // Make cards as matched
                cardView.setStatusAnimated(.matched)
                alreadyRevealedCardView.setStatusAnimated(.matched) { _ in
                    // Check if game ended
                    if self.cardViews.allSatisfy({ $0.card.status == .matched }) {
                        self.delegate?.gameDidEnd(self)
                    }
                }
            }
        }
        else {
            // Unreveal all revealed cards
            for revealedCard in alreadyRevealedCards {
                revealedCard.setStatusAnimated(.hidden)
            }
        }
    }
}
