//
//  Client.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import Foundation
import UIKit

class Client {
    
    struct Auth {
        static var sessionId = ""
        static var accountId = ""
        static var firstName = ""
        static var lastName = ""
        static var uniqueKey = ""
    }
    
    enum EndPoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let session = "/session"
        
        case login
        case getStudentLocations
        case logout
        case getUserInfo
        case post
        
        var stringValue: String {
            switch self {
            case .login:
                return Client.EndPoints.base + Client.EndPoints.session
            case .getStudentLocations:
                return Client.EndPoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .logout:
                return Client.EndPoints.base + Client.EndPoints.session
            case .getUserInfo:
                return Client.EndPoints.base + "/users/\(Auth.accountId)"
            case .post:
                return Client.EndPoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, isUserInfo: Bool, completion: @escaping (Result<ResponseType, Error>) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
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
                    let newData = removeFirstFiveCharacters(data)
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
        
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<ResponseType: Decodable, PostType: Encodable>(url: URL, responseType: ResponseType.Type, body: PostType, login: Bool, completion: @escaping(Result<ResponseType, Error>) -> Void) -> Void {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(body)
        if login {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
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
                    let newData = removeFirstFiveCharacters(data)
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
        
        task.resume()
        
    }
    
    class func getAllLocations(completion: @escaping (Error?) -> Void) -> Void {
        taskForGETRequest(url: EndPoints.getStudentLocations.url, responseType: StudentResult.self, isUserInfo: false) { result in
            
            switch result {
            case .success(let results):
                StudentList.allStudents = results.results
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = UdacityLogin(udacity: UserLogin(username: username, password: password))
        taskForPOSTRequest(url: EndPoints.login.url, responseType: LoginResponse.self, body: body, login: true) { result in
            
            switch result {
            case .success(let response):
                Auth.sessionId = response.session.id
                Auth.accountId = response.account.key
                completion(true, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    class func post(student: PostLocation, completion: @escaping(Bool, Error?) -> Void) {
        taskForPOSTRequest(url: EndPoints.post.url, responseType: PostResponse.self, body: student, login: false) { result in
            
            switch result {
            case .success(_):
                completion(true, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping(Bool, Error?) -> Void) {
        var request = URLRequest(url: EndPoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }

            let newData = removeFirstFiveCharacters(data)
            print(String(data: newData, encoding: .utf8)!)
            Auth.sessionId = ""
            completion(true, nil)
        }
        task.resume()
    }
    
    class func getUserInfo(completion: @escaping(Bool, Error?) -> Void) {
        taskForGETRequest(url: EndPoints.getUserInfo.url, responseType: UserDetails.self, isUserInfo: true) { result in
            
            switch result {
            case .success(let response):
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                Auth.uniqueKey = response.key
                completion(true, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    class func removeFirstFiveCharacters(_ data: Data) -> Data {
        let range = 5..<data.count
        return data.subdata(in: range)
    }
}
