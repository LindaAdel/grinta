//
//  MatchesViewController.swift
//  grinta
//
//  Created by Linda adel on 25/08/2023.
//

import UIKit

class MatchesViewController: UIViewController {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var toggleButton: UISwitch!
    @IBOutlet weak var matchesTableView: UITableView! {
        didSet{
            matchesTableView.delegate = self
            matchesTableView.dataSource = self
        }
    }
    
    //MARK: - @variables
    var isToggleOn: Bool = false
    var sections: [String] = []
    var rowsBySection: [String: [MatchesDataModel]] = [:]
    var matchesList = [MatchesDataModel]()
    let matchesViewModel = MatchesViewModel()
    
    //MARK: - @Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleButton.isOn = isToggleOn
        matchesViewModel.bindMatchesViewModelToView =  onSuccessUpdateView
        matchesViewModel.bindViewModelErrorToView = onFailUpdateView
        matchesViewModel.fetchMatchesDataFromAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(showAlert(notification:)), name: Notification.Name("NetworkMessage"), object: nil)

    
    }
    
    //MARK: - @IBAction
    @IBAction func toggleButtonAction(_ sender: UISwitch) {
        isToggleOn = sender.isOn
        self.UpdateUI()
    }
    
    @objc func showAlert(notification: NSNotification) {
        if let message = notification.object as? String {
            AlertManager.showErrorAlertWith(message: message, with: self)
        }
    }
  
    //MARK: - @functions
    func onSuccessUpdateView(){
        matchesList = matchesViewModel.matchesData
        sections = matchesViewModel.arrangeRowWithAssociatedSectionByDate().0
        rowsBySection = matchesViewModel.arrangeRowWithAssociatedSectionByDate().1
        self.UpdateActifityIndicatorState()
        self.UpdateUI()
    }
    
    func onFailUpdateView(){
        AlertManager.showErrorAlertWith(message: matchesViewModel.showError, with: self)
    }
    
    func scrollToFirstSectionByCurrentDate() {
        let currentDate = DateManager().getCurrentDate()
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
    func UpdateActifityIndicatorState() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
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
                    return DatabaseManager.shared.isMatchFavorite(id: match.id?.description ?? "")
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
                        return DatabaseManager.shared.isMatchFavorite(id: match.id?.description ?? "")
                    }
                    matchObject = favoritedRows[indexPath.row]
                } else {
                    matchObject = rows[indexPath.row]
                }
                self.setCellInformation(in: cell, with: matchObject)
                self.handleAddingFavouriteMatch(from: cell, with: matchObject)
        }
        return cell
    }
    
    func toggleFavoriteStatus(for match: MatchesDataModel) {
        if let id = match.id?.description {
            if DatabaseManager.shared.isMatchFavorite(id: id) {
                DatabaseManager.shared.removeFavoriteMatch(id: id)
            } else {
                DatabaseManager.shared.addFavoriteMatch(with: match)
            }
        }
    }
    
    func getMatchTime(utcDate : String) -> String{
        let matchTime = DateManager().getScheduledMatchTimeInLocalTime(utcDate: utcDate)
        return matchTime
    }
    
    // Populate the cell with the match data as needed
    func setCellInformation(in cell:MatchesTableViewCell ,with matchObject: MatchesDataModel?) {
        if let homeTeam = matchObject?.homeTeam , let awayTeam = matchObject?.awayTeam , let utcDate = matchObject?.utcDate ,let status = matchObject?.status
        {
            cell.firstTeam.text = homeTeam.name
            cell.secondTeam.text = awayTeam.name

            if status.uppercased() == "SCHEDULED" {
                cell.Score.text = "\(status)"
                cell.result.text = "\(self.getMatchTime(utcDate: utcDate))  \(DateManager.currentTimeZone ?? "")"
                
            }else if status.uppercased() == "IN_PLAY" {
                if let score = matchObject?.score?.winner {
                    cell.Score.text = "\(status):\(score)"
                }
                if let result = matchObject?.score {
                    let result = matchesViewModel.calculateMatchScore(with: result)
                    cell.result.text = "\(result.0) : \(result.1)"}
            }else {
                if let score = matchObject?.score?.winner {
                    cell.Score.text = "\(status):\(score)"
                }
                if let result = matchObject?.score {
                    let result = matchesViewModel.calculateMatchScore(with: result)
                    cell.result.text = "\(result.0) : \(result.1)"}
            }
        }
    }
    
    // handle favouriting match object
    func handleAddingFavouriteMatch(from cell:MatchesTableViewCell ,with matchObject: MatchesDataModel?) {
        if let id = matchObject?.id?.description , let matchObject = matchObject {
            cell.isFavorite = DatabaseManager.shared.isMatchFavorite(id: id)
            // Set up the favorite button tap callback
            cell.didTapFavouriteButton = { [weak self] in
                self?.toggleFavoriteStatus(for: matchObject)
            }
        }
    }
}
