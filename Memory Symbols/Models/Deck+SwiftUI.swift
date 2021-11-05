import SwiftUI


extension Deck: Identifiable {
    var id: String { rawValue }
    
    var iconName: String {
        cardNames().first ?? ""
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

