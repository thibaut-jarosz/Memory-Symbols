import UIKit

/// Deck of cards
enum Deck: String, CaseIterable {
    case transport
    case weather
}

extension Deck {
    private func cardNames() -> [String] {
        guard let data = NSDataAsset(name: rawValue)?.data else {
            return []
        }
                
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
    
    /// Generate cards
    /// - Returns: generated cards
    func generateCards(numberOfPairs: Int) -> [Card] {
        let color = cardsColor
        let cards = cardNames()
            .prefix(numberOfPairs)
            .map { Card(name: $0, color: color) }
        
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
    
    /// Icon representing the deck
    var icon: UIImage? {
        guard let name = cardNames().first else { return nil }
        
        return UIImage(systemName: name)
    }
    
    /// Localized name of the deck
    var localizedName: String {
        NSLocalizedString("deck.name.\(self.rawValue)", comment: "")
    }
}
