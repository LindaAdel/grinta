//
//  NetworkManager.swift
//  grinta
//
//  Created by Linda adel on 25/08/2023.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static var sharedInstance = NetworkManager()
    
    static var IS_CONNECTED_TO_INTERNET: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
