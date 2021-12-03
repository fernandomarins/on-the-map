//
//  LoginResponse.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct Account: Codable {
    let registered: Bool
    let key: String
}
