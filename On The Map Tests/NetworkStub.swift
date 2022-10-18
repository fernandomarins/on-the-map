//
//  NetworkStub.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 16/10/22.
//
import Foundation
@testable import On_The_Map

struct NetworkStub: APIServiceProtocol {
    
    var session: URLSessionProtocol //= URLSession.shared
    
    var successfully: Result<Bool, Error>?
    
    func getAllLocations(completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(true))
    }
    
    func login(username: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(true))
    }
    
    func post(student: PostLocation, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(true))
    }
    
    func logout(completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(true))
    }
    
    func getUserInfo(completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(true))
    }
}

var mockAllLocations: Data? {
    """
    {
        "results":[
            {
                "createdAt": "2015-02-25T01:10:38.103Z",
                "firstName": "Jarrod",
                "lastName": "Parkes",
                "latitude": 34.7303688,
                "longitude": -86.5861037,
                "mapString": "Huntsville, Alabama ",
                "mediaURL": "https://www.linkedin.com/in/jarrodparkes",
                "objectId": "JhOtcRkxsh",
                "uniqueKey": "996618664",
                "updatedAt": "2015-03-09T22:04:50.315Z"
            },
            {
                "createdAt":"2015-02-24T22:27:14.456Z",
                "firstName":"Jessica",
                "lastName":"Uelmen",
                "latitude":28.1461248,
                "longitude":-82.756768,
                "mapString":"Tarpon Springs, FL",
                "mediaURL":"www.linkedin.com/in/jessicauelmen/en",
                "objectId":"kj18GEaWD8",
                "uniqueKey":"872458750",
                "updatedAt":"2015-03-09T22:07:09.593Z"
            },
            {
                "createdAt":"2015-02-24T22:30:54.442Z",
                "firstName":"Jason",
                "lastName":"Schatz",
                "latitude":37.7617,
                "longitude":-122.4216,
                "mapString":"18th and Valencia, San Francisco, CA",
                "mediaURL":"http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
                "objectId":"hiz0vOTmrL",
                "uniqueKey":"2362758535",
                "updatedAt":"2015-03-10T17:20:31.828Z"
            },
            {
                "createdAt": "2015-02-24T22:35:30.639Z",
                "firstName": "Gabrielle",
                "lastName": "Miller-Messner",
                "latitude": 35.1740471,
                "longitude": -79.3922539,
                "mapString": "Southern Pines, NC",
                "mediaURL": "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en",
                "objectId": "8ZEuHF5uX8",
                "uniqueKey": "2256298598",
                "updatedAt": "2015-03-09T22:06:11.615Z"
            }
        ]
    }
    """.data(using: .utf8)
}
