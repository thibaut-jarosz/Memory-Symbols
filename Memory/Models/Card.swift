import UIKit
/// Represents a single card
struct Card {
    /// Card Status
    enum Status {
        /// Card is hidden
        case hidden
        /// Card if revealed but not matched with another card
        case revealed
        /// Card is matched with another card
        case matched
    }
    
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
