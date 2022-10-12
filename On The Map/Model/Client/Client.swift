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
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, isUserInfo: Bool, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                
                if isUserInfo {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let responseObject = try decoder.decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<ResponseType: Decodable, PostType: Encodable>(url: URL, responseType: ResponseType.Type, body: PostType, login: Bool, completion: @escaping(ResponseType?, Error?) -> Void) -> Void {
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
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                if login {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let responseObj = try decoder.decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObj, nil)
                    }
                } else {
                    let responseObj = try decoder.decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObj, nil)
                    }
                }

            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
        
    }
    
    class func getAllLocations(completion: @escaping ([Student], Error?) -> Void) -> Void {
        taskForGETRequest(url: EndPoints.getStudentLocations.url, responseType: StudentResult.self, isUserInfo: false) { response, error in
            
            if let response = response {
                StudentList.allStudents = response.results
                completion(response.results, nil)
            } else {
                completion([], error)
            }
            
        }
    }

    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = UdacityLogin(udacity: UserLogin(username: username, password: password))
        taskForPOSTRequest(url: EndPoints.login.url, responseType: LoginResponse.self, body: body, login: true) { response, error in
            
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.accountId = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func post(student: Student?, completion: @escaping(Bool, Error?) -> Void) {
        
        let body = PostLocation(uniqueKey: student?.uniqueKey ?? "", firstName: student?.firstName ?? "", lastName: student?.lastName ?? "", mapString: student?.mapString ?? "", mediaURL: student?.mediaURL ?? "", latitude: student?.latitude ?? 0.0, longitude: student?.longitude ?? 0.0)
        
        taskForPOSTRequest(url: EndPoints.post.url, responseType: PostResponse.self, body: body, login: false) { response, error in
            
            if response != nil {
                completion(true, nil)
            } else {
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

            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            Auth.sessionId = ""
            completion(true, nil)
        }
        task.resume()
    }
    
    class func getUserInfo(completion: @escaping(Bool, Error?) -> Void) {
        taskForGETRequest(url: EndPoints.getUserInfo.url, responseType: UserDetails.self, isUserInfo: true) { response, error in
            
            if let response = response {
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                Auth.uniqueKey = response.key
                print(Auth.firstName)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
}
