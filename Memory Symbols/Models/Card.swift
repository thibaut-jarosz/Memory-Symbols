import UIKit

/// Represents a single card
struct Card: Identifiable, Equatable, Codable {
    /// Card Status
    enum Status: CaseIterable, Codable {
        /// Card is hidden
        case hidden
        /// Card if revealed but not matched with another card
        case revealed
        /// Card is matched with another card
        case matched
    }
    
    /// Card unique identifier
    var id = UUID()
    
    /// Deck of the card
    let deck: Deck
    
    /// Name of the card
    let name: String
    
    /// Status of the card
    var status: Status = .hidden
}
