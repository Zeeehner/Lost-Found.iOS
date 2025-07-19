//
//  InputSection.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct RegisterSection: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Binding var animateFields: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            CustomTextField(
                text: $authViewModel.email,
                contentDescription: "Email",
                icon: "envelope.fill",
                isSecure: false
            )
            .opacity(animateFields ? 1 : 0)
            .offset(x: animateFields ? 0 : -50)
            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1), value: animateFields)
            
            CustomTextField(
                text: $authViewModel.username,
                contentDescription: "Username",
                icon: "person.fill",
                isSecure: false
            )
            .opacity(animateFields ? 1 : 0)
            .offset(x: animateFields ? 0 : -50)
            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2), value: animateFields)
            
            CustomTextField(
                text: $authViewModel.password,
                contentDescription: "Password",
                icon: "lock.fill",
                isSecure: true
            )
            .opacity(animateFields ? 1 : 0)
            .offset(x: animateFields ? 0 : -50)
            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3), value: animateFields)
            
            CustomTextField(
                text: $authViewModel.confirmPassword,
                contentDescription: "Confirm Password",
                icon: "lock.fill",
                isSecure: true
            )
            .opacity(animateFields ? 1 : 0)
            .offset(x: animateFields ? 0 : -50)
            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.4), value: animateFields)
            
        }
    }
}


#Preview {
    RegisterSection(animateFields: .constant(true))
        .environmentObject(AuthViewModel())
}
