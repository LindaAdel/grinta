//
//  NetworkRouter.swift
//  grinta
//
//  Created by Linda adel on 25/08/2023.
//

import Foundation
import Alamofire

enum NetworkRouter: BaseRouter {
    case getMatches
    
    var method: HTTPMethod {
        switch self {
        case .getMatches:
            return .get
        }
        
    }
    var authorized: Bool {
        switch self {
        default:
            return true
        }
    }
    var path: String {
        switch self {
        case .getMatches:
            return NetworkConstants.path.matches
        }
    }
    
    
    
}
