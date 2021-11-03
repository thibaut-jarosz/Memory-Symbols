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
        
        let color = cardsColor
        
        let cards = try? JSONDecoder()
            .decode([String].self, from: data)
            .shuffled()
            .prefix(numberOfPairs)
            .map { Card(name: $0, color: color) }
        
        guard let cards = cards else {
            return []
        }
        return cards + cards
    }
    
    /// Cards color
    var cardsColor: UIColor {
        switch self {
        case .transport:
            return .systemGreen
        case .weather:
            return .systemBlue
        }
    }
}
