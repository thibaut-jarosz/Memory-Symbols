import UIKit

/// A controller that manage all the app
class MainViewController: UIViewController {
    /// A set of cards
    var cardSet: CardSet? = .weather
    
    /// The cards container
    let cardsContainerViewController = CardsContainerViewController()
    
    /// A view displayed when game ended
    var gameEndedView: UIView?
    
    /// Is game ended
    var isGameEnded: Bool {
        gameEndedView != nil
    }
}

// MARK: - View Loading
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add cards container
        cardsContainerViewController.delegate = self
        cardsContainerViewController.cardSet = cardSet
        view.addSubview(cardsContainerViewController.view)
    }
}

// MARK: - Actions
extension MainViewController {
    /// Restart the game
    @objc func restartGame() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            // Restart the game and hide gameEndedView
            self.cardsContainerViewController.restartGame(afterMovingCardsAway: self.isGameEnded)
            self.gameEndedView?.alpha = 0
        } completion: { _ in
            // Remove gameEndedView, shuffle the cards and restart timer
            self.gameEndedView?.removeFromSuperview()
            self.cardsContainerViewController.shuffleCards()
        }
    }
}

// MARK: Score
extension MainViewController {
    /// Get and set the best score for the current difficulty
    var bestScore: Int {
        get {
            UserDefaults.standard.integer(forKey: "bestScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "bestScore")
        }
    }
}

// MARK: - CardsContainerViewControllerDelegate
extension MainViewController: CardsContainerViewControllerDelegate {
    func gameDidEnd(_ cardContainer: CardsContainerViewController) {
        // Retrieve current and best score
        let currentScore = cardsContainerViewController.score
        var bestScore: Int {
            let value = self.bestScore
            if value <= 0 {
                return currentScore
            }
            return value
        }
        
        // Add gameEndedView
        insertGameEndedView(currentScore: currentScore, bestScore: bestScore)
        
        // Update best score
        if bestScore > currentScore {
            self.bestScore = currentScore
        }
        
        // Move cards away and present gameEndedView
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.cardsContainerViewController.moveCardsAway()
            self.gameEndedView?.alpha = 1
        } completion: { _ in
            self.cardsContainerViewController.hideAllCards()
        }
    }
    
    /// Add and configure  gameEndedView
    private func insertGameEndedView(currentScore: Int, bestScore: Int) {
        let mainFrame = cardsContainerViewController.view.frame
        
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
            currentScore
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
                bestScore > currentScore ? "BEST_SCORE_PREVIOUS" : "BEST_SCORE_CURRENT",
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