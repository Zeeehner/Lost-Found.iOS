//
//  AuthViewModel.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import Foundation
import Supabase

@MainActor
class AuthViewModel: ObservableObject {
    
    var myUser: [User?] = []
    
    // Properties
    @Published var user: User?
    @Published var isLoggingIn = false
    @Published var isRegistering = false
    @Published var isBreathing = false
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var isBlank: Bool = false
    @Published var goBackToLogin: Bool = false
    
    let emailRegEx = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,49}$"
    
    // Computed property that returns the current user's ID
    var currentUserID: String? {
        return user?.id.uuidString
    }
    
    // Computed property that checks if the user is logged in
    var isLoggedIn: Bool {
        return user != nil
    }
    
    // Computed property to check if the entered email is valid using the regex pattern
    var isValidEmail: Bool {
        if email.isEmpty {
            return true
        } else if !email.isEmpty && email.isValid(regexes: [emailRegEx]) {
            return true
        } else {
            return false
        }
    }
    
    // Computed property to check if the input data for registration is valid
    var isRegisterInputValid: Bool {
        if isRegistering {
            return !email.isEmpty && !username.isEmpty && !password.isEmpty && password == confirmPassword && password.count >= 6
        } else {
            return !username.isEmpty && !password.isEmpty
        }
    }
    
    var noInput: Bool {
        if goBackToLogin {
            isRegistering = false
            return email.isEmpty && username.isEmpty && password.isEmpty
        } else {
            return false
        }
    }
    
    
    // Function to register a new user with email and password
    func registerEmailPassword(email: String, userName: String, password: String, confirmPassword: String) {
        // Fixed the logic bug in original code
        guard !email.isEmpty, !userName.isEmpty, !password.isEmpty, password == confirmPassword, password.count >= 6 else {
            errorMessage = "Please fill all fields correctly. Password must be at least 6 characters."
            return
        }
        
        // Check email validity
        guard email.isValid(regexes: [emailRegEx]) else {
            errorMessage = "Please enter a valid email address."
            return
        }
        
        // Simulate successful registration
        print("Registration successful!")
        
        user = User(id: UUID(), username: userName, email: email, password: password)
        clearInputs()
        errorMessage = ""
    }
    
    // Function to login existing user
    func loginUserNamePassword(userName: String, password: String) {
        guard !userName.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both username and password."
            return
        }
        
        // Demo login - always successful for demo purposes
        // In real app, verify against stored users or API
        if userName.lowercased() == "demo" && password == "123456" {
            user = User(id: UUID(), username: userName, email: "demo@example.com", password: password)
            clearInputs()
            errorMessage = ""
        } else {
            // For demo, create user anyway
            user = User(id: UUID(), username: userName, email: "", password: password)
            clearInputs()
            errorMessage = ""
        }
    }
    
    func logout() {
        user = nil
        clearInputs()
    }
    
    func clearInputs() {
        email = ""
        username = ""
        password = ""
        confirmPassword = ""
    }
    
    
    func performAuth() {
        Task {
            await MainActor.run {
                isLoggingIn = true
            }
            
            // Simulate network delay
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            
            await MainActor.run {
                if isRegistering {
                    registerEmailPassword(
                        email: email,
                        userName: username,
                        password: password,
                        confirmPassword: confirmPassword
                    )
                } else {
                    loginUserNamePassword(
                        userName: username,
                        password: password
                    )
                }
                isLoggingIn = false
                
            }
        }
    }
}
