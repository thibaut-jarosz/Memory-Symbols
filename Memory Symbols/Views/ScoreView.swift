import UIKit

class ScoreView: UIView {
    @IBOutlet var scoreLabel: UILabel?
    @IBOutlet var bestScoreLabel: UILabel?
    
    func updateView(withScore score: Int, bestScore: Int) {
        scoreLabel?.text = .localizedStringWithFormat(
            NSLocalizedString("score.current", comment: ""),
            score
        )
        bestScoreLabel?.text = .localizedStringWithFormat(
            NSLocalizedString(bestScore > score ? "score.best.previous" : "score.best.current", comment: ""),
            bestScore
        )
    }
}
