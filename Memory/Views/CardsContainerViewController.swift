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
    
    /// Revealed cards but not matched yet
    var revealedCards = Set<CardView>(minimumCapacity: 2)
}


// MARK: - View Loading
extension CardsContainerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cards = try? JSONDecoder()
            .decode([String].self, from: NSDataAsset(name: "Weather")?.data ?? Data())
        
        let frame = CGRect(x: 3, y: 125, width: 314, height: 349)
        view.frame = frame
        
        // Create all cards
        let cardFrame = CGRect(x: frame.size.width/2, y: frame.size.height/2, width: 0, height: 0)
        for _ in 0..<2 {
            for card in cards ?? [] {
                let cardView = CardView(cardValue: card)
                cardView.frame = cardFrame
                cardView.delegate = self
                view.addSubview(cardView)
            }
        }
        
        // Shuffle cards after creating them
        shuffleCards()
    }
}


// MARK: - Cards management
extension CardsContainerViewController {
    /// Returns all cards
    private var allCards: [CardView] {
        view.subviews.compactMap { $0 as? CardView }
    }
    
    /// Shuffle the cards
    func shuffleCards() {
        // Get all the cards and shuffle them
        let cards = allCards.shuffled()
        
        // Update the cards frames
        UIView.transition(with: view, duration: 0.5) {
            for (index, cardView) in cards.enumerated() {
                cardView.frame = .init(
                    x: 35*((index/10)%9),
                    y: 35*(index%10),
                    width: 34,
                    height: 34
                )
            }
        }
    }
    
    /// Hide all the cards
    func hideAllCards() {
        for cardView in allCards {
            cardView.setStatusAnimated(.hidden)
        }
    }
    
    /// Restart the game by hiding all cards
    /// - Parameter afterMovingCardsAway: Restart occured after moving cards away
    func restartGame(afterMovingCardsAway: Bool) {
        score = 0
        revealedCards.removeAll()
        if afterMovingCardsAway {
            // Put back all the cards that were moved away
            moveCards(away: false)
        }
        else {
            // Just hide the cards
            hideAllCards()
        }
    }
    
    /// Move away all cards
    func moveCardsAway() {
        moveCards(away: true)
    }
    
    private func moveCards(away: Bool) {
        let containerHalfWidth = view.frame.width/2
        for cardView in allCards {
            let centerX = cardView.center.x
            let moveLeft: Bool = away && centerX < containerHalfWidth || !away && centerX >= containerHalfWidth
            cardView.center.x = moveLeft ? (centerX - containerHalfWidth - 30) : (centerX + containerHalfWidth + 30)
        }
    }
}


// MARK: - CardViewDelegate
extension CardsContainerViewController: CardViewDelegate {
    
    /// Manage action when card has been touched
    /// - Parameter cardView: the touched card
    func touchesBegan(on cardView: CardView) {
        // Check if card was hidden
        guard cardView.status == .hidden else { return }
        
        // Increase score and reveal card
        score += 1
        cardView.setStatusAnimated(.revealed)
        
        // If only 1 card was revealed before touching the card
        if revealedCards.count == 1, let alreadyRevealedCardView = revealedCards.first {
            
            // If card is matching
            if cardView.cardValue == alreadyRevealedCardView.cardValue {
                // Make cards as matched
                cardView.setStatusAnimated(.matched)
                alreadyRevealedCardView.setStatusAnimated(.matched) { _ in
                    // Check if game ended
                    if self.allCards.allSatisfy({ $0.status == .matched }) {
                        self.delegate?.gameDidEnd(self)
                    }
                }
                // Remove all revealed but not matched cards
                revealedCards.removeAll()
            }
            else {
                // Insert touched card in revealed but not matched list
                revealedCards.insert(cardView)
            }
        }
        else {
            // Unreveal all revealed cards
            for revealedCard in revealedCards {
                revealedCard.setStatusAnimated(.hidden)
            }
            revealedCards.removeAll()
            // Mark touched card as revealed but not matched
            revealedCards.insert(cardView)
        }
    }
}
