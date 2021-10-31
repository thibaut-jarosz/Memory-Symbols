import UIKit

/// Set of cards
enum CardSet: String, CaseIterable {
    case weather
}

extension CardSet {
    /// Generate cards
    /// - Returns: generated cards
    func generateCards() -> [Card] {
        guard let data = NSDataAsset(name: rawValue)?.data else {
            return []
        }
        
        let cards = try? JSONDecoder()
            .decode([String].self, from: data)
            .map { name in
                Card(name: name)
            }
        
        guard let cards = cards else {
            return []
        }
        return cards + cards
    }
}
