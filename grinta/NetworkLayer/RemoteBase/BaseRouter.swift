//
//  BaseRouter.swift
//  grinta
//
//  Created by Linda adel on 25/08/2023.
//

import Foundation
import Alamofire

protocol BaseRouter: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var authorized: Bool { get }
}

extension BaseRouter {
    

    var authorized: Bool {
      return true
    }
   
    var parameters: Parameters? {
       return nil
    }
    
    var tokenHeader: [String: String] {
        return [NetworkConstants.HTTPHeader.Token: AppConfiguration.apiKey]
    }

    func asURLRequest() throws -> URLRequest {
        let url = try AppConfiguration.apiBaseURL.asURL()
        var urlRequest = URLRequest(url: URL(string: url.appendingPathComponent(path).absoluteString.removingPercentEncoding ?? "") ?? url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if authorized {
            urlRequest.setValue(tokenHeader.first?.value, forHTTPHeaderField: tokenHeader.first?.key ?? "")
        }
        
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
}
