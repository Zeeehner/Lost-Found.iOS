//
//  LoginView.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var animateFields: Bool = false
    @State private var isBreathing: Bool = false
    @State private var showLogo: Bool = false
    
    var body: some View {
        NavigationStack {
             GeometryReader { geometry in
                 ZStack {
                     // Background
                     GradientBackround()
                     
                     VStack(spacing: 30) {
                         // Logo Section
                         VStack(spacing: 20) {
                             BreathingLogo(isBreathing: $isBreathing, showLogo: $showLogo)
                             Branding(showLogo: $showLogo)
                         }
                         .padding(.top, geometry.safeAreaInsets.top + 20)
                         
                         Spacer()
                         
                         // Form Section
                         VStack(spacing: 20) {
                             // Input Fields
                             VStack(spacing: 15) {
                                 if authViewModel.isRegistering {
                                     RegisterSection(animateFields: $animateFields)
                                 } else {
                                     LoginSection(animateFields: $animateFields)
                                 }
                             }
                             .padding(.horizontal, 20)
                             
                             // Login/Register Button
                             CustomButton()
                                 .padding(.horizontal, 20)
                                 .padding(.top, 10)
                         }
                         
                         Spacer()
                         
                         // Switch Mode Button
                         SignUpChoice(animateFields: $animateFields)
                             .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                     }
                 }
             }
             .onAppear {
                 authViewModel.isBreathing = true
                 showLogo = true
                 
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                     animateFields = true
                 }
             }
             .onDisappear {
                 authViewModel.isBreathing = false
             }
             .navigationDestination(isPresented: .constant(authViewModel.isLoggedIn)) {
                 OnboardingView()
                     .environmentObject(authViewModel)
             }
         }
     }
 }


#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
    
}
