//
//  MatchesViewController.swift
//  grinta
//
//  Created by Linda adel on 25/08/2023.
//

import UIKit

class MatchesViewController: UIViewController {
    
    @IBOutlet weak var toggleButton: UISwitch!
    @IBOutlet weak var matchesTableView: UITableView! {
        didSet{
            matchesTableView.delegate = self
            matchesTableView.dataSource = self
        }
    }
    
    var isToggleOn: Bool = false
    var sections: [String] = []
    var rowsBySection: [String: [MatchesDataModel]] = [:]
    var matchesList = [MatchesDataModel]()
    let matchesViewModel = MatchesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleButton.isOn = isToggleOn
        matchesViewModel.bindMatchesViewModelToView =  onSuccessUpdateView
        matchesViewModel.bindViewModelErrorToView = onFailUpdateView
        matchesViewModel.fetchMatchesDataFromAPI()
    }
    
    @IBAction func toggleButtonAction(_ sender: UISwitch) {
        isToggleOn = sender.isOn
        self.UpdateUI()
    }
    
    func onSuccessUpdateView(){
        matchesList = matchesViewModel.matchesData
        sections = matchesViewModel.arrangeRowWithAssociatedSectionByDate().0
        rowsBySection = matchesViewModel.arrangeRowWithAssociatedSectionByDate().1
        self.UpdateUI()
    }
    
    func onFailUpdateView(){
        let alert = UIAlertController(title: "Error", message: matchesViewModel.showError, preferredStyle: .alert)
        let okAction  = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func scrollToFirstSectionByCurrentDate() {
        let currentDate = self.matchesViewModel.getCurrentDate()
        // Find the target section index based on the current date
        var targetSectionIndex =  self.sections.firstIndex(where: { $0 >= currentDate})
        // If today's date is not found, get the next available date
        if targetSectionIndex == nil {
            targetSectionIndex =  self.sections.firstIndex(where: { $0 > currentDate })
        }
        if let sectionIndex = targetSectionIndex {
            // Scroll to the desired section
            let indexPath = IndexPath(row: 0, section: sectionIndex)
            self.matchesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func UpdateUI() {
        DispatchQueue.main.async {
            self.matchesTableView.reloadData()
            self.scrollToFirstSectionByCurrentDate()
        }
    }
}

extension MatchesViewController :UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //get the name of the section
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDate = sections[section]
            if isToggleOn {
                let favoritedRows = rowsBySection[sectionDate]?.filter { match in
                    return DatabaseManager.shared.isItemFavorite(id: match.id?.description ?? "")
                }
                return favoritedRows?.count ?? 0
            } else {
                return rowsBySection[sectionDate]?.count ?? 0
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchesTableViewCell", for: indexPath) as! MatchesTableViewCell
        let sectionDate = sections[indexPath.section]
        var matchObject: MatchesDataModel?
            if let rows = rowsBySection[sectionDate] {
                if isToggleOn {
                    let favoritedRows = rows.filter { match in
                        return DatabaseManager.shared.isItemFavorite(id: match.id?.description ?? "")
                    }
                    matchObject = favoritedRows[indexPath.row]
                } else {
                    matchObject = rows[indexPath.row]
                }
            // Populate the cell with the match data as needed
            if let homeTeam = matchObject?.homeTeam , let awayTeam = matchObject?.awayTeam , let score = matchObject?.score{
                cell.firstTeam.text = homeTeam.name
                cell.secondTeam.text = awayTeam.name
                cell.Score.text = score.winner
            }
            if let id = matchObject?.id?.description , let matchObject = matchObject {
                cell.isFavorite = DatabaseManager.shared.isItemFavorite(id: id)
                // Set up the favorite button tap callback
                cell.didTapFavouriteButton = { [weak self] in
                    self?.toggleFavoriteStatus(for: matchObject)
                }
            }
        }
        return cell
    }
    
    func toggleFavoriteStatus(for match: MatchesDataModel) {
        if let id = match.id?.description {
            if DatabaseManager.shared.isItemFavorite(id: id) {
                DatabaseManager.shared.removeFavoriteItem(id: id)
            } else {
                DatabaseManager.shared.addFavoriteMatch(with: match)
            }
        }
    }
    
}
