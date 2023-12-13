//
//  APIProtocol.swift
//  On The Map
//
//  Created by Fernando Marins on 15/10/22.
//

import Foundation
import CoreLocation

protocol URLSessionProtocol {
    func fetchData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    func fetchDataRequest(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

protocol APIProtocol {
    var session: URLSessionProtocol { get }
    func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, isUserInfo: Bool, completion: @escaping (Result<ResponseType, Error>) -> Void) -> Void
    func taskForPOSTRequest<ResponseType: Decodable, PostType: Encodable>(url: URL, responseType: ResponseType.Type, body: PostType, login: Bool, completion: @escaping(Result<ResponseType, Error>) -> Void) -> Void
    func taskForDELETERequest(url: URL, completion: @escaping (Result<Bool, Error>) -> Void) -> Void
}

protocol APIServiceProtocol: APIProtocol {
    func getAllLocations(completion: @escaping (Result<Bool, Error>) -> Void) -> Void
    func login(username: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func post(student: PostLocation, completion: @escaping(Result<Bool, ApiError>) -> Void)
    func logout(completion: @escaping(Result<Bool, Error>) -> Void)
    func getUserInfo(completion: @escaping(Result<Bool, ApiError>) -> Void)
    func geocodeLocation(_ location: String, completion: @escaping (Result<CLLocation, ApiError>) -> Void)
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
            
            if let error = error {
                 completion(.failure(error))
                 return
             }
            
            guard let response = response as? HTTPURLResponse, (200...210).contains(response.statusCode) else {
                completion(.failure(ApiError.responseError))
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiError.invalidData))
                return
            }
            
            do {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: isUserInfo ? newData : data)
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            } catch {
                completion(.failure(ApiError.parse))
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
            
            if let error = error {
                 completion(.failure(error))
                 return
             }
            
            guard let response = response as? HTTPURLResponse, (200...210).contains(response.statusCode) else {
                completion(.failure(ApiError.responseError))
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiError.invalidData))
                return
            }
            
            do {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let responseObj = try JSONDecoder().decode(ResponseType.self, from: login ? newData : data)
                DispatchQueue.main.async {
                    completion(.success(responseObj))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func taskForDELETERequest(url: URL, completion: @escaping (Result<Bool, Error>) -> Void) -> Void {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        session.fetchDataRequest(with: request) { data, response, error in
            
            if let error = error {
                 completion(.failure(error))
                 return
             }
            
            guard let response = response as? HTTPURLResponse, (200...210).contains(response.statusCode) else {
                completion(.failure(ApiError.responseError))
                return
            }
            
            guard data != nil else {
                completion(.failure(ApiError.invalidData))
                return
            }

            completion(.success(true))
        }
    }
}
