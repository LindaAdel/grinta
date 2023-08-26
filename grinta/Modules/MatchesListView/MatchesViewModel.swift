//
//  MatchesViewModel.swift
//  grinta
//
//  Created by Linda adel on 25/08/2023.
//

import Foundation

class MatchesViewModel: NSObject {
    var matchesRepository: MatchesRepository!
    var sections: [String] = []
    var rowsBySection: [String: [MatchesDataModel]] = [:]
    
    var matchesData:[MatchesDataModel]! {
        didSet{
            self.bindMatchesViewModelToView()
        }
    }
    
    var showError : String! {
        didSet{
            self.bindViewModelErrorToView()
        }
        
    }
    
    
    var bindMatchesViewModelToView : (()->()) = {}
    var bindViewModelErrorToView : (()->()) = {}
    
   
    
override init() {
        super.init()
        self.matchesRepository = MatchesRepository.shared
    }
    
    
 func fetchMatchesDataFromAPI (){
        
        matchesRepository.getLeagueMatches { matchesDataResponse, error in
            if let error : Error = error{
                
                let message = error.localizedDescription
                self.showError = message
                
            }else{
                if let matches = matchesDataResponse?.matches {
                    self.matchesData = matches
                }
            }
           
        }
    }
    
    func arrangeRowWithAssociatedSectionByDate() ->([String],[String: [MatchesDataModel]]){
        for matchObject in matchesData {
            if let utcDate = matchObject.utcDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                if let date = dateFormatter.date(from: utcDate) {
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let sectionDate = dateFormatter.string(from: date)
                    
                    if !sections.contains(sectionDate) {
                        sections.append(sectionDate)
                    }
                    if var rows = rowsBySection[sectionDate] {
                        rows.append(matchObject)
                        rowsBySection[sectionDate] = rows
                    } else {
                        rowsBySection[sectionDate] = [matchObject]
                    }
                }
            }
        }
        return (sections,rowsBySection)
    }
    
    func sortSectionByDate(with sections: [String]){
        var sections = sections
        sections.sort(by: {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date1 = dateFormatter.date(from: $0), let date2 = dateFormatter.date(from: $1) {
                return date1 < date2
            }
            return false
        })
    }
    
    func getCurrentDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Customize the date format as per your requirements
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
}
