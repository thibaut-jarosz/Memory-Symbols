import UIKit

/// Deck of cards
enum Deck: String, CaseIterable {
    case communication
    case currencies
    case gamecontroller
    case hands
    case nature
    case media
    case persons
    case shapes
    case transport
    case weather
}

extension Deck {
    func cardNames() -> [String] {
        guard let data = NSDataAsset(name: rawValue)?.data else {
            return []
        }
                
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
    
    /// Generate cards
    /// - Returns: generated cards
    func generateCards(numberOfPairs: Int) -> [Card] {
        let cardNames = cardNames()
            .prefix(numberOfPairs)
        
        return (cardNames + cardNames)
            .map { Card(deck: self, name: $0) }
    }
    
    /// Cards color
    var cardsColor: UIColor {
        switch self {
        case .communication:
            return .systemBlue
        case .currencies:
            return .systemOrange
        case .gamecontroller:
            return .systemPink
        case .hands:
            return .systemPurple
        case .media:
            return .systemIndigo
        case .nature:
            return .systemGreen
        case .persons:
            return .systemBrown
        case .shapes:
            return .systemMint
        case .transport:
            return .systemRed
        case .weather:
            return .systemCyan
        }
    }
    
    /// Icon representing the deck
    var icon: UIImage? {
        guard let name = cardNames().first else { return nil }
        
        return UIImage(systemName: name)
    }
    
    /// Localized name of the deck
    var localizedName: String {
        NSLocalizedString("\(rawValue)", tableName: "DeckNames", comment: "")
    }
}
