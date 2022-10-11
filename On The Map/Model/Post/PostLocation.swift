//
//  PostLocation.swift
//  On The Map
//
//  Created by Fernando Marins on 11/10/22.
//

import Foundation

struct PostLocation: Encodable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
