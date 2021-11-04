import UIKit

/// A controller that manage a game
class GameViewController: UIViewController {
    /// Number of columns on the board
    static let columns: Int = 7
    
    /// Number of rows on the board
    static let rows: Int = 8
    
    /// Number of pairs on the board
    static var pairs: Int { columns * rows / 2 }
    
    /// A deck of cards
    var deck: Deck = .weather
    
    /// The board that contains all cards
    @IBOutlet var boardView: BoardView?
    
    /// A score view displayed when game ended
    @IBOutlet var scoreView: ScoreView?
    
    /// Game score (lower is better)
    var score: Int = 0
}

// MARK: - View Loading
extension GameViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = deck.localizedName
        
        // Configure boardView
        boardView?.cardViews = deck
            .generateCards(numberOfPairs: Self.pairs)
            .compactMap(CardView.init(card:))
            .shuffled()
        
        // Configure scoreView
        scoreView?.alpha = 0
    }
}

// MARK: - Actions
extension GameViewController {
    /// Restart the game
    @IBAction func restartGame() {
        guard let boardView = boardView else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            // Restart the game and hide gameEndedView
            self.score = 0
            boardView.transform = .init(scaleX: 1, y: 1)
            boardView.alpha = 1
            self.scoreView?.alpha = 0
        } completion: { _ in
            // Shuffle the cards
            boardView.cardViews = boardView.cardViews.shuffled()
            UIView.transition(with: boardView, duration: 0.5) {
                boardView.layoutIfNeeded()
            }
        }
    }
}

// MARK: Score
extension GameViewController {
    /// Get and set the best score for the current difficulty
    var bestScore: Int {
        get {
            UserDefaults.standard.integer(forKey: "\(deck.rawValue)-bestScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(deck.rawValue)-bestScore")
        }
    }
}

// MARK: - BoardViewDelegate
extension GameViewController: BoardViewDelegate {
    func numberOfColumns(in boardView: BoardView) -> Int {
        Self.columns
    }
    
    func boardView( _ boardView: BoardView, touchesBeganOn cardView: CardView) {
        // Check if card was hidden
        guard cardView.status == .hidden else { return }
        
        // Get currently revealed CardViews
        let otherRevealedCardViews = boardView.cardViews.filter { $0.status == .revealed }
        
        // Increase score and reveal card
        score += 1
        setStatusAnimated(.revealed, to: cardView)
        
        // If only 1 card was revealed before touching the card
        if otherRevealedCardViews.count == 1, let otherRevealedCardView = otherRevealedCardViews.first {
            
            // If card is matching
            if cardView.card.name == otherRevealedCardView.card.name {
                // Make cards as matched
                setStatusAnimated(.matched, to: cardView)
                setStatusAnimated(.matched, to: otherRevealedCardView) { _ in
                    // Check if game ended
                    if boardView.cardViews.allSatisfy({ $0.status == .matched }) {
                        self.gameDidEnd()
                    }
                }
                
                // Add cancel button instead of back button
                if navigationItem.leftBarButtonItem == nil {
                    navigationItem.setLeftBarButton(.init(
                        title: NSLocalizedString("cancel.button", comment: ""),
                        style: .done,
                        target: self,
                        action: #selector(cancelGame)
                    ), animated: true )
                }
            }
        }
        else {
            // Unreveal all revealed cards
            for otherRevealedCardView in otherRevealedCardViews {
                setStatusAnimated(.hidden, to: otherRevealedCardView)
            }
        }
    }
    
    @IBAction func cancelGame() {
        let unmatchedCount = boardView?.cardViews.filter { $0.status != .matched }.count ?? 0
        
        let alert = UIAlertController(title: String.localizedStringWithFormat(
            NSLocalizedString("cancel.alert.title", comment: ""),
            unmatchedCount
        ), message: nil, preferredStyle: .alert)
        
        alert.addAction(.init(
            title: NSLocalizedString("cancel.alert.goback", comment: ""),
            style: .cancel
        ))
        alert.addAction(.init(
            title: NSLocalizedString("cancel.alert.confirm", comment: ""),
            style: .destructive,
            handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }
        ))
        present(alert, animated: true)
    }
    
    /// Change the status of a card using animation
    /// - Parameters:
    ///   - status: The new status
    ///   - cardView: The card to update
    ///   - completion: Completion block called after animation
    private func setStatusAnimated(_ status: Card.Status, to cardView: CardView, completion: ((Bool) -> Void)? = nil) {
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

// Game end management
extension GameViewController {
    private func gameDidEnd() {
        // Retrieve current and best score
        var bestScore: Int {
            let value = self.bestScore
            if value <= 0 {
                return score
            }
            return value
        }
        
        // Update scoreView
        scoreView?.updateView(withScore: score, bestScore: bestScore)
        
        // Update best score
        if bestScore > score {
            self.bestScore = score
        }
        
        // Move cards away and present scoreView
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {            
            self.boardView?.transform = .init(scaleX: 5, y: 5)
            self.boardView?.alpha = 0
            self.scoreView?.alpha = 1
        } completion: { _ in
            // Hide all cards
            self.boardView?.cardViews.forEach { $0.status = .hidden }
        }
        
        // Remove cancel button and go back to back button
        navigationItem.setLeftBarButton(nil, animated: true)
    }
}
