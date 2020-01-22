
//  Created by Dylan  on 1/16/20.
//  Copyright © 2020 Dylan . All rights reserved.
//
import UIKit
import Foundation

/*
 - Utilized Protocol for the network calls to enable
 - Using Generics for JSONDecoder & fetchNetworkData so these methods can be reused if/when this application expands
 */

protocol API {
    var session: URLSession { get }
    
    func fetchNetworkData<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completionHandler completion: @escaping (Result<T, APIError>) -> Void)
}

extension API {
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    //MARK: - Decode JSON
    /* This function is responsible for parsing/decoding JSON. I'm using a Generic that conforms to decodable here so that this function can be used with any decoable object if the project expands and we need to fetch data from a new API.*/
    private func decodeJSON<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { (data, urlResponse, error) in
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                completion(nil, .httpRequestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                /* Success from the server, parse the JSON accordingly. Passing Generic codable object to the completion handler. */
                if let data = data {
                    do {
                        let model = try JSONDecoder().decode(decodingType, from: data)
                        completion(model, nil)
                    }
                    catch {
                        /* If this is hit there was an error parsing or decoding the JSON. Passing that error from custom API Error. */
                        completion(nil, .jsonConversionFailure)
                    }
                }
                else {
                    /* If we hit here, the data is empty. Passing custom error to alert the user that there is no data. */
                    completion(nil, .handleNoData)
                }
            }
            else {
                /* If we have hit this, there is a response other than 200 from the server. Passing HTTP error from custom API Error enum. */
                completion(nil, .httpResponseUnsuccessful)
            }
        }
        return task
    }
    
    //MARK: - Fetch Data Implementation
    func fetchNetworkData<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completionHandler completion: @escaping ((Result<T, APIError>)) -> Void) {
        let task = decodeJSON(with: request, decodingType: T.self) { (JSON, APIError) in
            guard let json = JSON else {
                if let apiError = APIError {
                    completion(Result.failure(apiError))
                }
                else {
                    completion(Result.failure(.jsonDataMalformed))
                }
                return
            }
            if let value = decode(json) {
                completion(.success(value))
            }
            else {
                completion(.failure(.jsonParsingFailure))
            }
        }
        task.resume()
    }
    
}


