//
//  StudentsList.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import Foundation

struct StudentResult: Codable {
    let results: [Student]
}

struct StudentList {
    static var allStudents = [Student]()
}
