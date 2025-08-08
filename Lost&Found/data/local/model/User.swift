//
//  User.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let email: String
    let registeredOn: Date
    
    init(
        id: UUID,
        email: String,
        registeredOn: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.registeredOn = registeredOn
    }
}
