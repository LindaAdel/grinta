//
//  NetworkDataSource.swift
//  grinta
//
//  Created by Linda adel on 25/08/2023.
//

import Foundation
protocol NetworkRemoteDataSource {
    
    func getLeagueMatches(completion: @escaping ((_ matchesResponse : ResponseDataModel?, _ error:APIError?) -> Void))
   
}

class NetworkAPI: BaseAPI, NetworkRemoteDataSource {
    
    func getLeagueMatches(completion: @escaping ((ResponseDataModel?,APIError?) -> Void)) {
        request(request: NetworkRouter.getMatches, responseType: ResponseDataModel.self, showDefaultErrorSnackbar: true){ response , error in
            if let response = response {
                completion(response,nil)
            }else {
                completion(nil, error)
            }
            
        }
    }
    
    
}
