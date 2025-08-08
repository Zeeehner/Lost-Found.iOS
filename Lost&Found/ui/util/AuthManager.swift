//
//  AuthManager.swift
//  Lost&Found
//
//  Created by Noah on 08.08.25.
//

import Foundation
import Supabase

@MainActor
class AuthManager {
    
    static let shared = AuthManager()
    
    private let client: SupabaseClient
     
     private init() {
         guard let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
               let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_KEY") as? String,
               let url = URL(string: urlString) else {
             fatalError("Supabase URL or Key not set in Info.plist")
         }
         
         client = SupabaseClient(supabaseURL: url, supabaseKey: key)
     }
    
    func isLoggedIn() async throws -> Bool {
        return try await currentUser != nil
    }
    
    var currentUser: Supabase.User? {
        get async throws {
            let session = try await client.auth.session
            return session.user
        }
    }
    
    func userId() async throws -> UUID? {
        return try await currentUser?.id
    }
    
    func signUp(email: String, password: String) async throws {
        let _ = try await client.auth.signUp(email: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws {
        let _ = try await client.auth.signIn(email: email, password: password)
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    func sendMagicLink(email: String) async throws {
        try await client.auth.signInWithOTP(email: email)
    }
    
    func resetPassword(email: String) async throws {
        try await client.auth.resetPasswordForEmail(
            email,
            redirectTo: URL(string: "myapp://reset-password"),
            captchaToken: nil
        )
    }
    
    func refreshSession() async throws {
        try await client.auth.refreshSession()
    }
    
    func validatePassword(_ password: String) -> (isValid: Bool, message: String?) {
        if password.count < 8 {
            return (false, "Passwort muss mindestens 8 Zeichen lang sein")
        }
        // TODO: limit password inputs for protec
        return (true, nil)
    }
}
