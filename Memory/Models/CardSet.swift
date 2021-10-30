import UIKit

/// Set of cards
enum CardSet: String, CaseIterable {
    case weather
}


extension CardSet {
    /// Name of all cards in set
    var names: [String]? {
        guard let data = NSDataAsset(name: rawValue)?.data else {
            return nil
        }
        return try? JSONDecoder().decode([String].self, from: data)
    }
}
