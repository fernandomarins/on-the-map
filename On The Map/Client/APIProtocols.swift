//
//  APIProtocol.swift
//  On The Map
//
//  Created by Fernando Marins on 15/10/22.
//

import Foundation

protocol URLSessionProtocol {
    func fetchData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    func fetchDataRequest(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

protocol APIProtocol {
    var session: URLSessionProtocol { get }
    func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, isUserInfo: Bool, completion: @escaping (Result<ResponseType, Error>) -> Void) -> Void
    func taskForPOSTRequest<ResponseType: Decodable, PostType: Encodable>(url: URL, responseType: ResponseType.Type, body: PostType, login: Bool, completion: @escaping(Result<ResponseType, Error>) -> Void) -> Void
}

protocol APIServiceProtocol: APIProtocol {
    func getAllLocations(completion: @escaping (Error?) -> Void) -> Void
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void)
    func post(student: PostLocation, completion: @escaping(Bool, Error?) -> Void)
    func logout(completion: @escaping(Bool, Error?) -> Void)
    func getUserInfo(completion: @escaping(Bool, Error?) -> Void)
}

extension URLSession: URLSessionProtocol {
    func fetchData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = dataTask(with: url, completionHandler: completionHandler)
        dataTask.resume()
    }
    
    func fetchDataRequest(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = dataTask(with: request, completionHandler: completionHandler)
        dataTask.resume()
    }
}

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