//
//  ResponseDataModel.swift
//  grinta
//
//  Created by Linda adel on 25/08/2023.
//

import Foundation

struct ResponseDataModel: Codable {
    var count: Int?
    var competition: CompetitionDataMode?
    var matches: [MatchesDataMode]?
    
}

struct CompetitionDataMode: Codable {
    var id: Int?
    var area: AreaDataModel?
    var name: String?
    var code: String?
    var plan : String?
    var lastUpdated: String?
}

struct MatchesDataMode: Codable {
    var id: Int?
    var season: SeasonDataModel?
    var utcDate: String?
    var status: String?
    var matchday: Int?
    var stage: String?
    var group:  String?
    var lastUpdated: String?
    var odds: OddsDataModel?
    var score: ScoreDataModel?
    var homeTeam: AreaDataModel?
    var awayTeam: AreaDataModel?
    var referees: [RefereesDataModel]?
    
}

struct AreaDataModel : Codable {
    var id: Int?
    var name: String?
}

struct SeasonDataModel : Codable {
    var id: Int?
    var startDate: String?
    var endDate: String?
    var currentMatchday: Int?
}

struct OddsDataModel : Codable {
    var msg: String?
}

struct ScoreDataModel : Codable {
    var winner: String?
    var duration: String?
    var fullTime: TimesDataModel?
    var halfTime: TimesDataModel?
    var extraTime: TimesDataModel?
    var penalties: TimesDataModel?
    
}

struct TimesDataModel : Codable {
    var homeTeam: Int?
    var awayTeam: Int?
}

struct RefereesDataModel : Codable {
    var id: Int?
    var name: String?
    var role: String?
    var nationality: String?
}
