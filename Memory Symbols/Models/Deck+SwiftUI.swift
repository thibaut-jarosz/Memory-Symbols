import SwiftUI


extension Deck: Identifiable {
    var id: String { rawValue }
    
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
}

