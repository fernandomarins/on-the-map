//
//  APIProtocol.swift
//  On The Map
//
//  Created by Fernando Marins on 15/10/22.
//

import Foundation

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

protocol URLSessionProtocol {
    func fetchData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    func fetchDataRequest(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
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
