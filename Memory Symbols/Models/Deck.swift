import SwiftUI

/// Deck of cards
enum Deck: String, CaseIterable, Identifiable {
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
    
    var id: String { rawValue }
}

extension Deck {
    /// Localized name of the deck
    var localizedName: String {
        NSLocalizedString("\(rawValue)", tableName: "DeckNames", comment: "")
    }
    
    /// List of all available card names
    var cardNames: [String] {
        guard let data = NSDataAsset(name: rawValue)?.data else {
            return []
        }
                
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
    
    /// Cards color
    var color: Color {
        switch self {
        case .communication:
            return .blue
        case .currencies:
            return .orange
        case .gamecontroller:
            return .pink
        case .hands:
            return .purple
        case .media:
            return .indigo
        case .nature:
            return .green
        case .persons:
            return .brown
        case .shapes:
            return .mint
        case .transport:
            return .red
        case .weather:
            return .cyan
        }
    }
    
    /// Icon representing the deck
    var iconName: String {
        switch self {
        case .communication:
            return "bubble.left"
        case .currencies:
            return "dollarsign.circle"
        case .gamecontroller:
            return "gamecontroller"
        case .hands:
            return "hand.raised"
        case .media:
            return "playpause"
        case .nature:
            return "leaf"
        case .persons:
            return "person"
        case .shapes:
            return "seal"
        case .transport:
            return "bicycle"
        case .weather:
            return "cloud.sun"
        }
    }
    
    /// Get and set the best score for the current deck
    var bestScore: Int {
        get {
            UserDefaults.standard.integer(forKey: "BestScore.\(rawValue)")
        }
        nonmutating set {
            UserDefaults.standard.set(newValue, forKey: "BestScore.\(rawValue)")
        }
    }
}
