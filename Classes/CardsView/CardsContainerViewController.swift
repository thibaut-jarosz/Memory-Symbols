import UIKit

/// Delegate of CardsContainerViewController
@objc protocol CardsContainerViewControllerDelegate {
    /// Called when game did end because all cards are revealed
    @objc func gameDidEnd(_ cardContainer: CardsContainerViewController)
}


/// A controller that manage all game cards
class CardsContainerViewController: UIViewController {
    /// Delegate of the CardsContainerViewController
    @objc var delegate: CardsContainerViewControllerDelegate?
    
    /// Number of cards revealed. One card can be revealed multiple times.
    @objc var revealCounter: Int = 0
    
    /// Revealed cards but not matched yet
    var revealedCards = Set<CardView>(minimumCapacity: 2)
}


// MARK: - View Loading
extension CardsContainerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 3, y: 75, width: 314, height: 349)
        view.frame = frame
        
        // Create all cards
        let cardFrame = CGRect(x: frame.size.width/2, y: frame.size.height/2, width: 0, height: 0)
        for _ in 0..<2 {
            for i in 0..<45 {
                let cardView = CardView(imageID: i)
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
    @objc func shuffleCards() {
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
    @objc func hideAllCards() {
        for cardView in allCards {
            cardView.reveal(false, animated: true)
            cardView.alpha = 1
        }
    }
    
    /// Restart the game by hiding all cards
    /// - Parameter afterMovingCardsAway: Restart occured after moving cards away
    @objc func restartGame(afterMovingCardsAway: Bool) {
        revealCounter = 0
        revealedCards.removeAll()
        if afterMovingCardsAway {
            // Put back all the cards that were moved away
            let containerHalfWidth = view.frame.width/2
            for cardView in allCards {
                let centerX = cardView.center.x
                cardView.center.x = centerX < containerHalfWidth ? (centerX + containerHalfWidth + 30) : (centerX - containerHalfWidth - 30)
            }
        }
        else {
            // Just hide the cards
            hideAllCards()
        }
    }
    
    /// Move away all cards
    @objc func moveCardsAway() {
        let containerHalfWidth = view.frame.width/2
        for cardView in allCards {
            let centerX = cardView.center.x
            cardView.center.x = centerX < containerHalfWidth ? (centerX - containerHalfWidth - 30) : (centerX + containerHalfWidth + 30)
        }
    }
}


// MARK: - CardViewDelegate
extension CardsContainerViewController: CardViewDelegate {
    
    /// Manage action when card has been touched
    /// - Parameter cardView: the touched card
    func touchesBegan(on cardView: CardView) {
        // Check if card was not already revealed
        guard !cardView.isRevealed else { return }
        
        // Increase counter and reveal card
        revealCounter += 1
        cardView.reveal(true, animated: true)
        
        // If only 1 card was revealed before touching the card
        if revealedCards.count == 1, let alreadyRevealedCardView = revealedCards.first {
            
            // If card is matching
            if cardView.imageID == alreadyRevealedCardView.imageID {
                // Make cards as matched
                UIView.animate(withDuration: 0.5) {
                    cardView.alpha = 0.5
                    alreadyRevealedCardView.alpha = 0.5
                } completion: { _ in
                    // Check if game ended
                    if let _ = self.allCards.first(where: { !$0.isRevealed }) {
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
                revealedCard.reveal(false, animated: true)
            }
            revealedCards.removeAll()
            // Mark touched card as revealed but not matched
            revealedCards.insert(cardView)
        }
    }
}
