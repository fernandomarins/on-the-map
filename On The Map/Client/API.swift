//
//  Client.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import Foundation
import UIKit

extension APIProtocol {
    func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, isUserInfo: Bool, completion: @escaping (Result<ResponseType, Error>) -> Void) -> Void {
        session.fetchData(with: url) { data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    if let error {
                        completion(.failure(error))
                    }
                }
                return
            }
            
            do {
                
                if isUserInfo {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(.success(responseObject))
                    }
                } else {
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(responseObject))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func taskForPOSTRequest<ResponseType: Decodable, PostType: Encodable>(url: URL, responseType: ResponseType.Type, body: PostType, login: Bool, completion: @escaping(Result<ResponseType, Error>) -> Void) -> Void {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(body)
        if login {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        session.fetchDataRequest(with: request) { data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    if let error {
                        completion(.failure(error))
                    }
                }
                return
            }
            
            do {
                if login {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let responseObj = try JSONDecoder().decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(.success(responseObj))
                    }
                } else {
                    let responseObj = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(responseObj))
                    }
                }

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

//class API: APIProtocol {
//    
//    
//    
//    func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, isUserInfo: Bool, completion: @escaping (Result<ResponseType, Error>) -> Void) -> Void {
//        session.fetchData(with: url) { data, response, error in
//            
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    if let error {
//                        completion(.failure(error))
//                    }
//                }
//                return
//            }
//            
//            do {
//                
//                if isUserInfo {
//                    let newData = self.removeFirstFiveCharacters(data)
//                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
//                    DispatchQueue.main.async {
//                        completion(.success(responseObject))
//                    }
//                } else {
//                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.success(responseObject))
//                    }
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func taskForPOSTRequest<ResponseType: Decodable, PostType: Encodable>(url: URL, responseType: ResponseType.Type, body: PostType, login: Bool, completion: @escaping(Result<ResponseType, Error>) -> Void) -> Void {
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = try? JSONEncoder().encode(body)
//        if login {
//            request.addValue("application/json", forHTTPHeaderField: "Accept")
//        }
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        session.fetchDataRequest(with: request) { data, response, error in
//            
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    if let error {
//                        completion(.failure(error))
//                    }
//                }
//                return
//            }
//            
//            do {
//                if login {
//                    let newData = self.removeFirstFiveCharacters(data)
//                    let responseObj = try JSONDecoder().decode(ResponseType.self, from: newData)
//                    DispatchQueue.main.async {
//                        completion(.success(responseObj))
//                    }
//                } else {
//                    let responseObj = try JSONDecoder().decode(ResponseType.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.success(responseObj))
//                    }
//                }
//
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//}
