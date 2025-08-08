//
//  AuthViewModelEx.swift
//  Lost&Found
//
//  Created by Noah on 08.08.25.
//

import Foundation

extension AuthViewModel {
    
    func handleRegister() {
        Task {
            await register()
        }
    }
    
    func handleLogin() {
        Task {
            await login()
        }
    }
    
    func handleLogout() {
        Task {
            await logout()
        }
    }
    
    func handleMagicLink() {
        Task {
            await sendMagicLink()
        }
    }
    
    func handlePasswordReset() {
        Task {
            await resetPassword()
        }
    }
}
