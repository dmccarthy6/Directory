
//  Created by Dylan  on 1/16/20.
//  Copyright © 2020 Dylan . All rights reserved.
//
import UIKit
import Foundation

protocol API {
    var session: URLSession { get }
    
    func fetchNetworkData<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completionHandler completion: @escaping (Result<T, APIError>) -> Void)
}

extension API {
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    //MARK: - Decode JSON
    private func decodeJSON<T: Decodable>(with request: URLRequest,
                                            decodingType: T.Type,
                                            completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { (data, urlResponse, error) in
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                //Success
                if let data = data {
                    do {
                        let model = try JSONDecoder().decode(decodingType, from: data)
                        completion(model, nil)
                    }
                    catch {
                        //Failed to convert JSON
                        completion(nil, .jsonConversionFailure)
                    }
                }
                else {
                    //Data is NIL
                    completion(nil, .invalidData)
                }
            }
            else {
                //Not Successful HTTP Response
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    //MARK: - Fetch Data Implementation
    func fetchNetworkData<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completionHandler completion: @escaping (Result<T, APIError>) -> Void) {
        let task = decodeJSON(with: request, decodingType: T.self) { (JSON, APIError) in
            //MAIN QUEUE
            DispatchQueue.main.async {
                guard let json = JSON else {
                    if let apiError = APIError {
                        completion(Result.failure(apiError))
                    }
                    else {
                        completion(Result.failure(.invalidData))
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
        }
        task.resume()
    }
    
    //Async Image Functions
    func getImageData(from url: URL, completion: @escaping (Result<Data?, APIError>) -> Void) {
        let imageTask = session.dataTask(with: url) { (imageData, response, error) in
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }
            guard let imageData = imageData else {
                completion(.failure(.invalidData))
                return
            }
            completion(.success(imageData))
        }
        imageTask.resume()
    }
    
    func asyncImageFrom(data: Data, _ completion: @escaping (Result<UIImage, APIError>) -> Void) {
        DispatchQueue.global().async {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            }
            else {
                completion(.failure(APIError.invalidData))
            }
        }
    }
    
    
}


