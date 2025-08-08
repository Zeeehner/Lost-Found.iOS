//
//  LoginSection.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct LoginSection: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Binding var animateFields: Bool
    
    var body: some View {
        VStack {
            CustomTextField(
                text: $authViewModel.email,
                contentDescription: "E-Mail",
                icon: "person.fill",
                isSecure: false
            )
            .opacity(animateFields ? 1 : 0)
            .offset(x: animateFields ? 0 : -50)
            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1), value: animateFields)
            
            CustomTextField(
                text: $authViewModel.password,
                contentDescription: "Password",
                icon: "lock.fill",
                isSecure: true
            )
            .opacity(animateFields ? 1 : 0)
            .offset(x: animateFields ? 0 : -50)
            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2), value: animateFields)
            .onSubmit {
                authViewModel.performAuth()
                
            }
        }
    }
}
