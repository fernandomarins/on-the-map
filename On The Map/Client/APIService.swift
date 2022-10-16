//
//  APIService.swift
//  On The Map
//
//  Created by Fernando Marins on 15/10/22.
//

import Foundation

class APIService {
    
    var session: URLSessionProtocol
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
   
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
                return EndPoints.base + EndPoints.session
            case .getStudentLocations:
                return EndPoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .logout:
                return EndPoints.base + EndPoints.session
            case .getUserInfo:
                return EndPoints.base + "/users/\(Auth.accountId)"
            case .post:
                return EndPoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
}

extension APIService: APIServiceProtocol {
    
    func getAllLocations(completion: @escaping (Error?) -> Void) -> Void {
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
    
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
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
    
    func post(student: PostLocation, completion: @escaping(Bool, Error?) -> Void) {
        taskForPOSTRequest(url: EndPoints.post.url, responseType: PostResponse.self, body: student, login: false) { result in
            
            switch result {
            case .success(_):
                completion(true, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    func logout(completion: @escaping(Bool, Error?) -> Void) {
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
            
            let newData = self.removeFirstFiveCharacters(data)
            Auth.sessionId = ""
            completion(true, nil)
        }
        task.resume()
    }
    
    func getUserInfo(completion: @escaping(Bool, Error?) -> Void) {
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
    
    func removeFirstFiveCharacters(_ data: Data) -> Data {
        let range = 5..<data.count
        return data.subdata(in: range)
    }
}
