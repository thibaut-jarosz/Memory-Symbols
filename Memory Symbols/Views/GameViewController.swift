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
    
    /// A view displayed when game ended
    var gameEndedView: UIView?
    
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
    }
}

// MARK: - Actions
extension GameViewController {
    /// Restart the game
    @objc func restartGame() {
        guard let boardView = boardView else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            // Restart the game and hide gameEndedView
            self.score = 0
            boardView.transform = .init(scaleX: 1, y: 1)
            boardView.alpha = 1
            self.gameEndedView?.alpha = 0
        } completion: { _ in
            // Remove gameEndedView, shuffle the cards and restart timer
            self.gameEndedView?.removeFromSuperview()
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
            }
        }
        else {
            // Unreveal all revealed cards
            for otherRevealedCardView in otherRevealedCardViews {
                setStatusAnimated(.hidden, to: otherRevealedCardView)
            }
        }
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
        
        // Add gameEndedView
        insertGameEndedView(bestScore: bestScore)
        
        // Update best score
        if bestScore > score {
            self.bestScore = score
        }
        
        // Move cards away and present gameEndedView
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {            
            self.boardView?.transform = .init(scaleX: 5, y: 5)
            self.boardView?.alpha = 0
            self.gameEndedView?.alpha = 1
        } completion: { _ in
            // Hide all cards
            self.boardView?.cardViews.forEach { $0.status = .hidden }
        }
    }
    
    /// Add and configure  gameEndedView
    private func insertGameEndedView(bestScore: Int) {
        let mainFrame = boardView?.frame ?? .zero
        
        // Add gameEndedView
        let gameEndedView = UIView(frame: mainFrame)
        gameEndedView.alpha = 0
        view.addSubview(gameEndedView)
        self.gameEndedView = gameEndedView
        
        // Add title
        let titleLabel = UILabel(frame: .init(x: 0, y: 50, width: mainFrame.size.width, height: 40))
        titleLabel.text = NSLocalizedString("GAME_OVER", value: "Well done!", comment: "")
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Marker Felt", size: 40)
        gameEndedView.addSubview(titleLabel)
        
        // Add restart button
        let restartButton = UIButton(frame: .init(x: 75, y: mainFrame.size.height-40, width: mainFrame.size.width-150, height: 40))
        restartButton.setTitle(NSLocalizedString("RESTART", value: "Restart", comment: ""), for: .normal)
        restartButton.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        restartButton.backgroundColor = .clear
        restartButton.titleLabel?.textColor = .white
        restartButton.titleLabel?.font = UIFont(name: "Marker Felt", size: 28)
        gameEndedView.addSubview(restartButton)
        
        // Add score label
        let scoreLabel = UILabel(frame: .init(x: 0, y: 125, width: mainFrame.size.width, height: 50))
        scoreLabel.text = String(
            format: NSLocalizedString(
                "GAME_SCORE",
                value: "You have touch the screen %i times to complete this game.",
                comment: ""
            ),
            score
        )
        scoreLabel.numberOfLines = 2
        scoreLabel.textAlignment = .center
        scoreLabel.backgroundColor = .clear
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont(name: "Marker Felt", size: 20)
        gameEndedView.addSubview(scoreLabel)
        
        // Add best score label
        let bestScoreLabel = UILabel(frame: .init(x: 0, y: 200, width: mainFrame.size.width, height: 50))
        bestScoreLabel.text = String(
            format: NSLocalizedString(
                bestScore > score ? "BEST_SCORE_PREVIOUS" : "BEST_SCORE_CURRENT",
                value: "Your best score is %i.",
                comment: ""
            ),
            bestScore
        )
        bestScoreLabel.numberOfLines = 2
        bestScoreLabel.textAlignment = .center
        bestScoreLabel.backgroundColor = .clear
        bestScoreLabel.textColor = .white
        bestScoreLabel.font = UIFont(name: "Marker Felt", size: 20)
        gameEndedView.addSubview(bestScoreLabel)
    }
}
