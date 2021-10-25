import UIKit

/// Delegate of CardView
protocol CardViewDelegate {
    /// Forward the touchesBegan to delegate
    func touchesBegan(on cardView: CardView)
}


/// A view representing a single card
class CardView: UIView {
    /// Card Status
    enum Status {
        /// Card is hidden
        case hidden
        /// Card if revealed but not matched with another card
        case revealed
        /// Card is matched with another card
        case matched
    }
    
    /// Delegate of the CardView
    var delegate: CardViewDelegate?
    
    /// Is the card revealed or is it showing its back
    var status: Status = .hidden {
        didSet {
            // Show or hide image when isRevealed is changed
            backgroundColor = status == .hidden ? .white : .init(patternImage: image)
            alpha = status == .matched ? 0.5 : 1
        }
    }
    
    /// Identifier of the image shown by the card
    let imageID: Int
    
    /// Image shown by the card
    private let image: UIImage
    
    init(imageID: Int) {
        self.imageID = imageID
        self.image = .init(named: "\(imageID).png")!
        
        super.init(frame: .zero)
        
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardView {
    /// Change the status of the card
    /// - Parameters:
    ///   - status: The new status
    ///   - completion: Completion block called after animation
    func setStatusAnimated(_ status: Status, completion: ((Bool) -> Void)? = nil) {
        guard self.status != status else { return }
        
        guard self.status != status else { return }
        
        let options: UIView.AnimationOptions
        switch status {
        case .hidden:
            options = .transitionFlipFromRight
        case .revealed:
            options = .transitionFlipFromLeft
        case .matched:
            options = .curveEaseInOut
        }
        
        UIView.transition(with: self, duration: 0.5, options: options, animations: {
            self.status = status
        }, completion: completion)
    }
}

extension CardView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Forward touchesBegan to delegate
        delegate?.touchesBegan(on: self)
    }
}
