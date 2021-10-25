import UIKit

/// Delegate of InfoViewController
@objc protocol InfoViewControllerDelegate {
    /// Game difficulty
    @objc var difficulty: Int {get set}
    
    /// Should display a confirmation before changing difficulty
    @objc var shouldConfirmDifficultyChange: Bool { get }
    
    /// ViewController did show
    @objc(didShowInfoViewConroller:) func didShow(_ infoViewConroller: InfoViewController)
    
    /// ViewController did hide
    @objc(didHideInfoViewConroller:) func didHide(_ infoViewConroller: InfoViewController)
}


/// Controller that manage the information view
@objc class InfoViewController: UIViewController {
    /// Delegate of InfoViewController
    @objc weak var delegate: InfoViewControllerDelegate?
}

// MARK: - View loading
extension InfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var frame = UIScreen.main.bounds
        frame.origin.y = frame.height
        view.frame = frame;
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
    
        insertDescriptionTextView()
        insertSeparator()
        insertDifficultyViews()
    }
    
    /// Add and configure an `about` TextView
    private func insertDescriptionTextView() {
        let textView = UITextView(frame: .init(x: 20, y: 90, width: view.frame.width-40, height: 160))
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        textView.font = .init(name: "Marker Felt", size:20)
        textView.text = """
            \(NSLocalizedString("INFO_DEV", value: "Development: Thibaut Jarosz", comment: ""))
            \(NSLocalizedString("INFO_ADAPT", value: "Adapted from a Kek's flash game", comment: ""))
            www.zanorg.com
            blog.zanorg.com
            """
        view.addSubview(textView)
    }
    
    /// Add a separator
    private func insertSeparator() {
        let separator = UIView(frame: .init(x: 20, y: 220, width: view.frame.width-40, height: 1))
        separator.backgroundColor = .white
        view.addSubview(separator)
    }
    
    /// Add difficulty compotents
    private func insertDifficultyViews() {
        let difficultyTitle = UILabel(frame: .init(x: 15, y: 250, width: view.frame.width-30, height: 30))
        difficultyTitle.backgroundColor = .clear
        difficultyTitle.textColor = .white
        difficultyTitle.textAlignment = .center
        difficultyTitle.numberOfLines = 2
        difficultyTitle.font = UIFont(name: "Marker Felt", size: 25)
        difficultyTitle.text = NSLocalizedString("DIFFICULTY", value: "Difficulty", comment: "")
        view.addSubview(difficultyTitle)
        
        let difficultyControl = UISegmentedControl(items: [
            NSLocalizedString("NORMAL", value: "Normal", comment: ""),
            NSLocalizedString("HARD", value: "Hard", comment: ""),
            NSLocalizedString("EXTREME", value: "Extreme", comment: ""),
        ])
        difficultyControl.selectedSegmentIndex = delegate?.difficulty ?? 0
        difficultyControl.center = .init(x: view.frame.width/2, y: 310)
        difficultyControl.addTarget(self, action: #selector(difficultyChanged), for: .valueChanged)
        view.addSubview(difficultyControl)
        
        let difficultyDescription = UILabel(frame: .init(x: 15, y: 340, width: view.frame.width-30, height: 60))
        difficultyDescription.backgroundColor = .clear
        difficultyDescription.font = UIFont(name: "Marker Felt", size: difficultyDescription.font.pointSize)
        difficultyDescription.textColor = .white
        difficultyDescription.textAlignment = .center
        difficultyDescription.numberOfLines = 3
        difficultyDescription.text = NSLocalizedString("DIFFICULTY_DESCRIPTION", value: "Hard and Extreme difficulties will respectivelly reorganize the table every 60 and 30 seconds.", comment: "")
        view.addSubview(difficultyDescription)
    }
}

// MARK: - View show & hide
extension InfoViewController {
    /// Show the Info view
    @objc func show() {
        var frame = view.frame
        frame.origin = .zero
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut) {
            self.view.frame = frame
        } completion: { _ in
            self.delegate?.didShow(self)
        }
    }
    
    /// Hide the Info view
    @objc func hide() {
        var frame = view.frame
        frame.origin = .init(x: 0, y: frame.height)
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut) {
            self.view.frame = frame;
        } completion: { _ in
            self.delegate?.didHide(self)
        }
    }
}

// MARK: - Difficulty management
extension InfoViewController {
    /// Difficulty value changed by user
    /// - Parameter sender: the segmented control that changed
    @objc func difficultyChanged(_ sender: UISegmentedControl) {
        // Do nothing if delegate is nil
        guard let delegate = delegate else { return }
        
        // Just forward the new value if the confirmation is not required
        guard delegate.shouldConfirmDifficultyChange else {
            delegate.difficulty = sender.selectedSegmentIndex
            return
        }
        
        // Show confirmation alert
        let alertController = UIAlertController(
            title: NSLocalizedString("CONFIRM_DIFFICULTY_CHANGE", value: "Changing difficulty needs to restart the game.", comment: ""),
            message: nil,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("CANCEL_BUTTON", value: "Cancel", comment: ""),
            style: .cancel, handler: { _ in
                // Revert to old value if cancelled
                sender.selectedSegmentIndex = delegate.difficulty
            }
        ))
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("CHANGE_BUTTON", value: "Change", comment: ""),
            style: .destructive, handler: { _ in
                // Forward the new value to delegate if confirmed
                delegate.difficulty = sender.selectedSegmentIndex
            }
        ))
        present(alertController, animated: true)
    }
}
