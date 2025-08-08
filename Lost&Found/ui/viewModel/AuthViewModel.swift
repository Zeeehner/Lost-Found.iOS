//
//  AuthViewModel.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import Supabase
import Foundation
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    
    // MARK: - Singleton
    static let shared = AuthViewModel()
    
    // MARK: - Dependencies
    private let authManager = AuthManager.shared
    
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var successMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var showingAlert: Bool = false
    @Published var isRegistering: Bool = false
    @Published var isUserLoggedIn: Bool = false
    @Published private(set) var canLogin: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        // Login button enabled, wenn Email + Passwort nicht leer sind
        Publishers.CombineLatest($email, $password)
            .map { !$0.0.trimmingCharacters(in: .whitespaces).isEmpty && !$0.1.isEmpty }
            .assign(to: \.canLogin, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Computed Properties
    var isValidEmail: Bool {
        email.isEmpty || isValidEmailFormat(email)
    }
    
    var canRegister: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        isValidEmail &&
        password == confirmPassword &&
        password.count >= 8 &&
        !isLoading
    }
    
    // MARK: - Auth Actions
    func checkLoginStatus() {
        Task {
            do {
                let loggedIn = try await authManager.isLoggedIn()
                await MainActor.run {
                    self.isUserLoggedIn = loggedIn
                }} catch {
                    await MainActor.run {
                        self.isUserLoggedIn = false
                    }
                }
        }
    }
    
    func register() async -> Bool {
        guard canRegister else {
            showError("Bitte alle Felder korrekt ausfüllen")
            return false
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await authManager.signUp(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
            await MainActor.run {
                self.successMessage = "Registrierung erfolgreich! Bitte überprüfe deine E-Mails."
            }
            return true
        } catch {
            await MainActor.run {
                self.showError(error.localizedDescription)
            }
            return false
        }
    }
    
    func login() async -> Bool {
        guard canLogin else {
            showError("Bitte E-Mail und Passwort eingeben")
            return false
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await authManager.signIn(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
            await MainActor.run {
                self.successMessage = "Erfolgreich eingeloggt"
                self.checkLoginStatus()
            }
            return true
        } catch {
            await MainActor.run {
                self.showError(error.localizedDescription)
            }
            return false
        }
    }
    
    func sendMagicLink() async {
        guard !email.isEmpty, isValidEmailFormat(email) else {
            showError("Bitte gültige E-Mail-Adresse eingeben")
            return
        }
        
        await performAuthAction {
            try await self.authManager.sendMagicLink(email: self.email)
            self.successMessage = "Magic Link wurde an \(self.email) gesendet!"
        }
    }
    
    func resetPassword() async {
        guard !email.isEmpty, isValidEmailFormat(email) else {
            showError("Bitte gültige E-Mail-Adresse eingeben")
            return
        }
        
        await performAuthAction {
            try await self.authManager.resetPassword(email: self.email)
            self.successMessage = "Password-Reset Link wurde an \(self.email) gesendet!"
        }
    }
    
    func logout() async {
        await performAuthAction {
            try await self.authManager.signOut()
            self.successMessage = "Erfolgreich abgemeldet"
            self.clearInputs()
            self.checkLoginStatus()
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .userDidLogout, object: nil)
            }
        }
    }
    
    func refreshSession() async {
        await performAuthAction {
            try await self.authManager.refreshSession()
        }
    }
    
    // MARK: - Helpers
    private func performAuthAction(_ action: @escaping () async throws -> Void) async {
        isLoading = true
        errorMessage = ""
        successMessage = ""
        
        defer { isLoading = false }
        
        do {
            try await action()
        } catch {
            showError(error.localizedDescription)
        }
    }
    
    // MARK: - Helper Properties
    var buttonGradientColors: (Color, Color) {
        if isRegistering {
            // Für Registrierung: Grün-Blau wenn valide, Grau wenn nicht
            return canRegister ? (.green, .blue) : (.gray, .gray.opacity(0.8))
        } else {
            // Für Login: Blau-Lila wenn valide, Grau wenn nicht
            return canLogin ? (.blue, .purple) : (.gray, .gray.opacity(0.8))
        }
    }
    
    var isButtonEnabled: Bool {
        if isLoading {
            return false
        }
        
        if isRegistering {
            // Bei Registrierung: Immer enabled (für Zurück-Button oder Register)
            return true
        } else {
            // Bei Login: Nur wenn Login möglich
            return canLogin
        }
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingAlert = true
    }
    
    private func isValidEmailFormat(_ email: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - UI Helpers
    func clearError() {
        errorMessage = ""
        showingAlert = false
    }
    
    func clearSuccess() {
        successMessage = ""
        showingAlert = false
    }
    
    func clearInputs() {
        email = ""
        password = ""
        confirmPassword = ""
        errorMessage = ""
        successMessage = ""
    }
    
    // MARK: - Toggle Register/Login
    func toggleToRegister() {
        isRegistering = true
        clearError()
    }
    
    func toggleToLogin() {
        isRegistering = false
        clearError()
    }
    
    // MARK: - Unified Auth Action
    func performAuth() {
        Task {
            if isRegistering {
                _ = await register()
            } else {
                _ = await login()
            }
        }
    }
}
