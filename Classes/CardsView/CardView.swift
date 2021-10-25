import UIKit

/// Delegate of CardView
protocol CardViewDelegate {
    /// Forward the touchesBegan to delegate
    func touchesBegan(on cardView: CardView)
}


/// A view representing a single card
class CardView: UIView {
    
    /// Delegate of the CardView
    var delegate: CardViewDelegate?
    
    /// Is the card revealed or is it showing its back
    private(set) var isRevealed: Bool = false {
        didSet {
            // Show or hide image when isRevealed is changed
            backgroundColor = isRevealed ? .init(patternImage: image) : .white
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
    /// Change the visibility of the card
    /// - Parameters:
    ///   - reveal: reveal or hide the card
    ///   - animated: animate the visibility change
    func reveal(_ reveal: Bool, animated: Bool) {
        guard self.isRevealed != reveal else { return }
        
        if animated {
            UIView.transition(
                with: self,
                duration: 0.5,
                options: reveal ? .transitionFlipFromLeft : .transitionFlipFromRight
            ) {
                self.isRevealed = reveal
            }
        }
        else {
            isRevealed = reveal
        }
    }
}

extension CardView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Forward touchesBegan to delegate
        delegate?.touchesBegan(on: self)
    }
}
