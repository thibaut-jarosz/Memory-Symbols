import UIKit

/// Set of cards
enum CardSet: String, CaseIterable {
    case transport
    case weather
}

extension CardSet {
    /// Generate cards
    /// - Returns: generated cards
    func generateCards(numberOfPairs: Int) -> [Card] {
        guard let data = NSDataAsset(name: rawValue)?.data else {
            return []
        }
        
        let cards = try? JSONDecoder()
            .decode([String].self, from: data)
            .shuffled()
            .prefix(numberOfPairs)
            .map { Card(name: $0) }
        
        guard let cards = cards else {
            return []
        }
        return cards + cards
    }
}
