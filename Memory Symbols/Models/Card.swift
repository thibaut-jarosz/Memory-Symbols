import UIKit

/// Represents a single card
struct Card: Identifiable, Equatable {
    /// Card Status
    enum Status: CaseIterable {
        /// Card is hidden
        case hidden
        /// Card if revealed but not matched with another card
        case revealed
        /// Card is matched with another card
        case matched
    }
    
    /// Card unique identifier
    let id = UUID()
    
    /// Deck of the card
    let deck: Deck
    
    /// Name of the card
    let name: String
    
    /// Status of the card
    var status: Status = .hidden
}
