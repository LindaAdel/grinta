//
//  BaseAPI.swift
//  grinta
//
//  Created by Linda adel on 25/08/2023.
//

import Foundation
import Alamofire

class BaseAPI {
    func request<T: Decodable>(request: URLRequestConvertible, responseType: T.Type, isRequestRequireAuthorization: Bool = true, showDefaultAlertError: Bool, completion: @escaping ((T?, APIError?) -> ())) {
        
        guard NetworkManager.IS_CONNECTED_TO_INTERNET else {
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: "NetworkMessage"),
                object: "Please check your internet connection"
            )
            completion(nil, APIError.connectionError)
            return
        }
        AF.request(request).validate().responseDecodable(of: T.self, queue: .main) { afResponse in
            
            var returnedError: APIError?
            var returnedResponse: T?
            switch afResponse.result {
                
            case .failure(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NetworkMessage"), object: returnedError?.message)
                if let httpResponse = afResponse.response {
                    returnedError = self.handleAPIError(httpResponse: httpResponse, responseData: afResponse.data)
                    if showDefaultAlertError {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NetworkMessage"), object: returnedError?.message)
                        if !isRequestRequireAuthorization {
                            completion(returnedResponse, returnedError)
                        }
                    } else {
                        completion(returnedResponse, returnedError)
                    }
                }
                if let error = returnedError {
                    print(error.localizedDescription)
                }
                
            case .success(let value):
                returnedResponse = value
                completion(returnedResponse, returnedError)
            }
            
            
            
        }
    }
    
    func handleAPIError(httpResponse: HTTPURLResponse, responseData: Data?) -> APIError? {
        if httpResponse.statusCode == 401 ||  httpResponse.statusCode == 400 || httpResponse.statusCode == 405 || httpResponse.statusCode == 404 || httpResponse.statusCode == 500
            || httpResponse.statusCode == 422 {
            
            var apiError: APIError? = nil
            if let data  = responseData {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    if let errors = json?["meta"] as? [String: Any], !errors.isEmpty {
                        apiError = APIError(responseCode: httpResponse.statusCode, customError: errors["message"] as? String)
                    }
                } catch {
                    print("error: \(error)")
                }
            }
    
            if apiError == nil {
                apiError = APIError(responseCode: httpResponse.statusCode)
            }
            return apiError
        }
        return .errorOccured
    }
   
}
