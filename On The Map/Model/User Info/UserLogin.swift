//
//  UserLogin.swift
//  On The Map
//
//  Created by Fernando Marins on 11/10/22.
//

import Foundation

struct UdacityLogin: Encodable {
    let udacity: UserLogin
}

struct UserLogin: Encodable {
    let username: String
    let password: String
}
