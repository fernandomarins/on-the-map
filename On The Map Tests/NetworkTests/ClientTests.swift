//
//  ClientTests.swift
//  On The Map Tests
//
//  Created by Fernando Marins on 17/10/22.
//

@testable import On_The_Map
import XCTest

final class ClientTests: XCTestCase {
    
    private let sutProtocol = NetworkStub(session: URLSession.shared)
    
    private var sut: APIService {
        let service = APIService(session: sutProtocol.session)
        return service
    }
    
    func testGetStudentsShouldPass() {
        var result: Result<Bool, Error>?
        sut.getAllLocations {
            result = $0
        }
        
        switch result {
        case .success(let success):
            XCTAssertTrue(success)
        default:
            break
        }
    }
    
    func testLoginShouldPass() {
        var result: Result<Bool, Error>?
        sut.login(username: "", password: "") {
            result = $0
        }
        
        switch result {
        case .success(let success):
            XCTAssertTrue(success)
        default:
            break
        }
    }
    
    func testPostShouldPass() {
        var result: Result<Bool, ApiError>?
        let postLocation = PostLocation(uniqueKey: "", firstName: "", lastName: "", mapString: "", mediaURL: "", latitude: 0.0, longitude: 0.0)
        sut.post(student: postLocation) {
            result = $0
        }
        
        switch result {
        case .success(let success):
            XCTAssertTrue(success)
        default:
            break
        }
    }
    
    func testLogoutShouldPass() {
        var result: Result<Bool, Error>?
        sut.logout {
            result = $0
        }
        
        switch result {
        case .success(let success):
            XCTAssertTrue(success)
        default:
            break
        }
    }
    
    func testGetUserInfoShouldPass() {
        var result: Result<Bool, ApiError>?
        sut.getUserInfo {
            result = $0
        }
        
        switch result {
        case .success(let success):
            XCTAssertTrue(success)
        default:
            break
        }
    }
}
