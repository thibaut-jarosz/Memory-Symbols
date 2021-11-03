import UIKit

class DeckSelectionViewController: UITableViewController {
}

// MARK: - Table view data source
extension DeckSelectionViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Deck.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        NSLocalizedString("deck.selection", comment: "")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)

        var config = cell.defaultContentConfiguration()
        
        let deck = Deck.allCases[indexPath.row]
        config.text = deck.localizedName
        config.image = deck.icon
        config.imageProperties.tintColor = deck.cardsColor
        
        cell.contentConfiguration = config
        return cell
    }
}

// MARK: - Navigation
extension DeckSelectionViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let selection = tableView.indexPathForSelectedRow,
            let gameViewController = segue.destination as? GameViewController
        else { return }
        
        gameViewController.deck = Deck.allCases[selection.row]
    }
}
