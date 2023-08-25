//
//  MatchesRepository.swift
//  grinta
//
//  Created by Linda adel on 25/08/2023.
//

import Foundation
protocol MatchesDataSource {
    
    func getLeagueMatches(completion: @escaping ((_ matchesResponse : ResponseDataModel?, _ error:APIError?) -> Void))
   
}
class MatchesRepository: MatchesDataSource {
    static let shared = MatchesRepository()
    private var remoteDataSource: NetworkRemoteDataSource
    
    private init() {
        self.remoteDataSource = NetworkAPI()
    }
    
    func getLeagueMatches(completion: @escaping ((ResponseDataModel?, APIError?) -> Void)) {
        self.remoteDataSource.getLeagueMatches { matchesResponse, error in
            completion(matchesResponse,error)
        }
    }
    
    
}
    
