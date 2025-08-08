//
//  CustomButton.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct CustomButton: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Error Message
            if !authViewModel.errorMessage.isEmpty {
                Text(authViewModel.errorMessage)
                    .foregroundStyle(.red)
                    .font(.system(size: 14, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.red.opacity(0.1))
                    .cornerRadius(8)
                    .scaleEffect(authViewModel.errorMessage.isEmpty ? 0 : 1)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: authViewModel.errorMessage.isEmpty)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                authViewModel.clearError()
                            }
                        }
                    }
            }
            
            // Success Message
            if !authViewModel.successMessage.isEmpty {
                Text(authViewModel.successMessage)
                    .foregroundStyle(.green)
                    .font(.system(size: 14, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.green.opacity(0.1))
                    .cornerRadius(8)
                    .scaleEffect(authViewModel.successMessage.isEmpty ? 0 : 1)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: authViewModel.successMessage.isEmpty)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                authViewModel.clearSuccess()
                            }
                        }
                    }
            }
            
            // Login / Register button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if authViewModel.isRegistering && !authViewModel.canRegister {
                        authViewModel.isRegistering = false
                        authViewModel.clearInputs()
                    } else {
                        Task {
                            if authViewModel.isRegistering {
                                let success = await authViewModel.register()
                                if success {
                                    authViewModel.isRegistering = false
                                    authViewModel.clearInputs()
                                }
                            } else {
                                let success = await authViewModel.login()
                                if success {
                                    authViewModel.clearInputs()
                                    await MainActor.run {
                                        authViewModel.isUserLoggedIn = true
                                    }
                                }
                            }
                        }
                    }
                }
            }) {
                HStack {
                    if authViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else if authViewModel.isRegistering && !authViewModel.canRegister {
                        // Zurück-Button
                        Label("Back to Login", systemImage: "arrow.left")
                            .font(.system(size: 18, weight: .semibold))
                    } else {
                        // Normale Darstellung mit Icon + Text
                        Image(systemName: authViewModel.isRegistering ? "person.badge.plus" : "person.badge.key")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text(authViewModel.isRegistering ? "Register" : "Login")
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            authViewModel.buttonGradientColors.0,
                            authViewModel.buttonGradientColors.1
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .cornerRadius(16)
                .scaleEffect(authViewModel.isLoading ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: authViewModel.isLoading)
            }
            .disabled(!authViewModel.isButtonEnabled)
        }
        .padding()
    }
}
