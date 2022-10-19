//
//  NetworkStub.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 16/10/22.
//
import Foundation
import CoreLocation
@testable import On_The_Map

struct NetworkStub: APIServiceProtocol {
    
    var session: URLSessionProtocol //= URLSession.shared
    
    var result: Result<Bool, Error> = .success(true)
    var resultLocation: Result<CLLocation, ApiError> = .success(CLLocation(latitude: 0.0, longitude: 0.0))
    
    func getAllLocations(completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(result)
    }
    
    func login(username: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(result)
    }
    
    func post(student: PostLocation, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(result)
    }
    
    func logout(completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(result)
    }
    
    func getUserInfo(completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(result)
    }
    
    func geocodeLocation(_ location: String, completion: @escaping (Result<CLLocation, ApiError>) -> Void) {
        completion(resultLocation)
    }
}
