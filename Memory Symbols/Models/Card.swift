import UIKit
/// Represents a single card
struct Card: Identifiable, Equatable {
    let id = UUID()
    
    /// Card Status
    enum Status {
        /// Card is hidden
        case hidden
        /// Card if revealed but not matched with another card
        case revealed
        /// Card is matched with another card
        case matched
    }
    
    /// Deck of the card
    let deck: Deck
    
    /// Name of the card
    let name: String
    
    /// Status of the card
    var status: Status = .hidden
}
extension Card {
    /// Image from name
    var image: UIImage? {
        UIImage(systemName: name)
    }
}
