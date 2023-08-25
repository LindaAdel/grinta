//
//  NetworkConstants.swift
//  grinta
//
//  Created by Linda adel on 25/08/2023.
//

import Foundation
struct NetworkConstants{
    
    struct ContentType {
        static let json = "application/json"
    }
    
    struct HTTPHeader {
        static let contentType = "Content-Type"
        static let acceptType = "Accept"
        static let authentication = "Authorization"
        static let timeZone = "timezone"
        static let language = "language"
        static let Token = "X-Auth-Token"
    }
    
    struct path {
        static let matches = "competitions/2021/matches"
    }
}
