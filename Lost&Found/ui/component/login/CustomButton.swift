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
                                authViewModel.errorMessage = ""
                            }
                        }
                    }
            }
            
            // Login / Register button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if authViewModel.isRegistering && !authViewModel.isRegisterInputValid {
                        authViewModel.isRegistering = false
                        authViewModel.clearInputs()
                    } else {
                        authViewModel.performAuth()
                    }
                }
            }) {
                HStack {
                    if authViewModel.isLoggingIn {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else if authViewModel.isRegistering && !authViewModel.isRegisterInputValid {
                        // Nur zurück-Pfeil und Text, KEIN weiteres Icon
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
                            authViewModel.isRegisterInputValid ? .green : .gray,
                            authViewModel.isRegisterInputValid ? .blue : .gray.opacity(0.8)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .cornerRadius(16)
                .scaleEffect(authViewModel.isLoggingIn ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: authViewModel.isLoggingIn)
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
