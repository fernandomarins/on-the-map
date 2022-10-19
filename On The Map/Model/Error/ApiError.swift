//
//  ApiError.swift
//  On The Map
//
//  Created by Fernando Marins on 16/10/22.
//

import Foundation


enum ApiError: Error {
    case responseError
    case invalidData
    case parse
    case geocodeError
}
