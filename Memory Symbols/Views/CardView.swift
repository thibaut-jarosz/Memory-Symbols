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
    
    /// Helper to access card status, especially because card cannot be modifier ouside CardView
    var status: Card.Status {
        get { card.status }
        set { card.status = newValue }
    }
    
    /// Delegate of the CardView
    weak var delegate: CardViewDelegate?
    
    /// Image shown by the card
    private let imageView = CardImageView()
    
    init(card: Card) {
        self.card = card
        
        super.init(frame: .zero)
        
        // Configure view
        backgroundColor = card.color
        translatesAutoresizingMaskIntoConstraints = false
        addConstraint(widthAnchor.constraint(
            equalTo: heightAnchor
        ))
        
        // Configure imageView
        imageView.image = card.image
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.tintColor = .systemBackground
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Forward touchesBegan to delegate
        delegate?.touchesBegan(on: self)
    }
}
