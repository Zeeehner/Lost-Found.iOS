//
//  UserEx.swift
//  Lost&Found
//
//  Created by Noah on 08.08.25.
//

import Supabase
import Foundation

extension User {
    init?(supabaseUser: Supabase.User) {
        guard let id = supabaseUser.id as UUID?,
              let email = supabaseUser.email else {
            return nil
        }
        let registeredOnDate = supabaseUser.createdAt
        self.init(
            id: id,
            email: email,
            registeredOn: registeredOnDate
        )
    }
}
