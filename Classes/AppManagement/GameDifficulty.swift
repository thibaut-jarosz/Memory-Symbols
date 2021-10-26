import Foundation

/// Difficulty of the game
enum GameDifficulty: Int, CaseIterable {
    case normal = 0
    case hard
    case extreme
}

extension GameDifficulty {
    /// Time between each cards shuffle
    ///
    /// `nil` value means no shuffle
    var shuffleTime: TimeInterval? {
        switch self {
        case .normal:
            return nil
        case .hard:
            return 30
        case .extreme:
            return 60
        }
    }
}
