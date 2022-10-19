//
//  APIService.swift
//  On The Map
//
//  Created by Fernando Marins on 15/10/22.
//

import Foundation
import CoreLocation

class APIService {
    
    let session: URLSessionProtocol
    
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
    func getAllLocations(completion: @escaping (Result<Bool, Error>) -> Void) -> Void {
        taskForGETRequest(url: EndPoints.getStudentLocations.url, responseType: StudentResult.self, isUserInfo: false) { result in
            
            switch result {
            case .success(let results):
                StudentList.allStudents = results.results
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func login(username: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let body = UdacityLogin(udacity: UserLogin(username: username, password: password))
        taskForPOSTRequest(url: EndPoints.login.url, responseType: LoginResponse.self, body: body, login: true) { result in
            
            switch result {
            case .success(let response):
                Auth.sessionId = response.session.id
                Auth.accountId = response.account.key
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func post(student: PostLocation, completion: @escaping(Result<Bool, ApiError>) -> Void) {
        taskForPOSTRequest(url: EndPoints.post.url, responseType: PostResponse.self, body: student, login: false) { result in
            
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(_):
                completion(.failure(.postError))
            }
        }
    }
    
    func logout(completion: @escaping(Result<Bool, Error>) -> Void) {
        taskForDELETERequest(url: EndPoints.logout.url) { result in
            switch result {
            case .success(_):
                Auth.sessionId = ""
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserInfo(completion: @escaping(Result<Bool, ApiError>) -> Void) {
        taskForGETRequest(url: EndPoints.getUserInfo.url, responseType: UserDetails.self, isUserInfo: true) { result in
            
            switch result {
            case .success(let response):
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                Auth.uniqueKey = response.key
                completion(.success(true))
            case .failure(_):
                completion(.failure(.getUserInfoError))
            }
        }
    }
    
    func geocodeLocation(_ location: String, completion: @escaping (Result<CLLocation, ApiError>) -> Void) {
        CLGeocoder().geocodeAddressString(location) { placemarks, error in
            if error != nil {
                completion(.failure(.geocodeError))
                return
            }
            
            if let placemark = placemarks?.first?.location {
                completion(.success(placemark))
            }
        }
    }
}
