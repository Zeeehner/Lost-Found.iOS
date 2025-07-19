//
//  User.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import Foundation

struct User: Codable {
    var id: UUID
    var username: String
    var email: String
    var password: String
    var registeredOn: String
    
    init(id: UUID, username: String, email: String, password: String, registeredOn: String = Date.now.ISO8601Format()) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.registeredOn = registeredOn
    }
}
