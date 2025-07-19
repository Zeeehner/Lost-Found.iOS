//
//  SignUpChoice.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct SignUpChoice: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Binding var animateFields: Bool
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                authViewModel.isRegistering.toggle()
                animateFields = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animateFields = true
                }
            }
        }) {
            HStack(spacing: 4) {
                Text(authViewModel.isRegistering ? "Already have an account?" : "Don't have an account?")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 16, weight: .medium))
                
                Text(authViewModel.isRegistering ? "Sign In" : "Sign Up")
                    .foregroundStyle(.green.opacity(0.7))
                    .font(.system(size: 16, weight: .semibold))
            }
        }
    }
}

#Preview {
    SignUpChoice(animateFields: .constant(true))
        .environmentObject(AuthViewModel())
}
