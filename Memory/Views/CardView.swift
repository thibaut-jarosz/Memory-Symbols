import UIKit

/// Delegate of CardView
protocol CardViewDelegate: AnyObject {
    /// Forward the touchesBegan to delegate
    func touchesBegan(on cardView: CardView)
}


/// A view representing a single card
class CardView: UIView {
    class CardImageView: UIImageView {
        override var intrinsicContentSize: CGSize {
            .init(
                width: UIView.noIntrinsicMetric,
                height: UIView.noIntrinsicMetric
            )
        }
    }
    
    /// Card associated to the view
    private(set) var card: Card {
        didSet {
            // Show or hide image when isRevealed is changed
            imageView.isHidden = card.status == .hidden
            alpha = card.status == .matched ? 0.5 : 1
        }
    }
    
    /// Delegate of the CardView
    weak var delegate: CardViewDelegate?
    
    /// Image shown by the card
    private let imageView = CardImageView()
    
    init(card: Card) {
        self.card = card
        
        super.init(frame: .zero)
        
        // Configure view
        backgroundColor = .white
        
        // Configure imageView
        imageView.image = card.image
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.tintColor = .init(named: "Card")
        addSubview(imageView)
        constrainImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Constraints management
extension CardView {
    private func constrainImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            imageView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            imageView.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            imageView.widthAnchor.constraint(
                equalTo: imageView.heightAnchor
            ),
            imageView.widthAnchor.constraint(
                equalTo: widthAnchor, multiplier: 0.8
            )
        ])
    }
}

extension CardView {
    /// Change the status of the card
    /// - Parameters:
    ///   - status: The new status
    ///   - completion: Completion block called after animation
    func setStatusAnimated(_ status: Card.Status, completion: ((Bool) -> Void)? = nil) {
        guard card.status != status else { return }
        
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
            self.card.status = status
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
