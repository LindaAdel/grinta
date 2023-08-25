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
    
//    var jsonHeader: [String: String] {
//       return [NetworkConstants.HTTPHeader.contentType: NetworkConstants.ContentType.json,
//               NetworkConstants.HTTPHeader.timeZone: TimeZone.current.identifier,
//               NetworkConstants.HTTPHeader.language: Locale.current.language.languageCode?.identifier ?? "en"]
//    }
    
    var tokenHeader: [String: String] {
        return [NetworkConstants.HTTPHeader.Token: AppConfiguration.apiKey]
    }

    func asURLRequest() throws -> URLRequest {
        let url = try AppConfiguration.apiBaseURL.asURL()
        var urlRequest = URLRequest(url: URL(string: url.appendingPathComponent(path).absoluteString.removingPercentEncoding ?? "") ?? url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
//        for header in self.jsonHeader {
//            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
//        }

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
        
        debugRequest(urlRequest: urlRequest)
        return urlRequest
    }

    private func debugRequest(urlRequest: URLRequest) {
        print("************************************************************")
        print("======================= URL ================================")
        print(urlRequest.url ?? "")
        print()
        print("======================= Headers ============================")
        print(urlRequest.headers)
        if let body = urlRequest.httpBody {
            print("======================= Body ===========================")
            print(String(data: body, encoding: .utf8) ?? "")
        }
        print("************************************************************")
    }
}
