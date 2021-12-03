//
//  UserInfo.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import Foundation

struct UserInfo: Codable {
    let user: UserDetails
}

struct UserDetails: Codable {
    let firstName: String
    let lastName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}
