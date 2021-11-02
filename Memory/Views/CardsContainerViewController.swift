import UIKit

/// Delegate of CardsContainerViewController
protocol CardsContainerViewControllerDelegate: AnyObject {
    /// Called when a card is touched
    func cardsContainer(
        _ cardsContainer: CardsContainerViewController,
        touchesBeganOn cardView: CardView
    )
}


/// A controller that manage all game cards
class CardsContainerViewController: UIViewController {
    /// Delegate of the CardsContainerViewController
    weak var delegate: CardsContainerViewControllerDelegate?
    
    /// List of CardView
    var cardViews: [CardView] = []
    
    /// All constraints that manage CardViews position
    var cardsLayoutContraints: [NSLayoutConstraint] = []
}


// MARK: - View Loading
extension CardsContainerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure CardViews
        cardViews.forEach { cardView in
            cardView.delegate = self
            view.addSubview(cardView)
        }
        
        // update layout
        shuffleCards(animated: false)
    }
}


// MARK: - Cards management
extension CardsContainerViewController {
    /// Shuffle the cards
    /// - Parameter animated: Shuffle must be animated
    func shuffleCards(animated: Bool) {
        cardViews = cardViews.shuffled()
        updateCardsLayoutContraints()
        if animated {
            UIView.transition(with: view, duration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    /// Hide all the cards
    func hideAllCards() {
        cardViews.forEach { $0.status = .hidden }
    }
    
    /// Change the status of a card using animation
    /// - Parameters:
    ///   - status: The new status
    ///   - cardView: The card to update
    ///   - completion: Completion block called after animation
    func setStatusAnimated(_ status: Card.Status, to cardView: CardView, completion: ((Bool) -> Void)? = nil) {
        guard cardView.status != status else { return }
        
        let options: UIView.AnimationOptions
        switch status {
        case .hidden:
            options = .transitionFlipFromRight
        case .revealed:
            options = .transitionFlipFromLeft
        case .matched:
            options = .curveEaseInOut
        }
        
        UIView.transition(with: cardView, duration: 0.5, options: options, animations: {
            cardView.status = status
        }, completion: completion)
    }
}

// MARK: - Constraints
private extension CardsContainerViewController {
    func updateCardsLayoutContraints() {
        view.removeConstraints(cardsLayoutContraints)
        cardsLayoutContraints = []
        
        guard let firstCardView = cardViews.first else { return }
        
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
        
        cardsLayoutContraints = constraints
        view.addConstraints(cardsLayoutContraints)
    }
}


// MARK: - CardViewDelegate
extension CardsContainerViewController: CardViewDelegate {
    
    /// Manage action when card has been touched
    /// - Parameter cardView: the touched card
    func touchesBegan(on cardView: CardView) {
        // Just forward to delegate
        delegate?.cardsContainer(self, touchesBeganOn: cardView)
    }
}
