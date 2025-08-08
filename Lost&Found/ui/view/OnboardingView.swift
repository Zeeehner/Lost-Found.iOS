//
//  OnboardingView.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Binding var isUserLoggedIn: Bool
    
    @State private var animateConstruction = false
    @State private var animateTools = false
    @State private var showWelcome = false
    
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    ZStack {
                        // Background Gradient
                        GradientBackround()
                        VStack(spacing: 30) {
                            // Header Section
                            HeaderSection(showWelcome: $showWelcome)
                                .padding(.top, 55)
                            
                            Spacer()
                            
                            // Construction Section
                            AnimatedCircle(animateConstruction: $animateConstruction)
                                .scaleEffect(showWelcome ? 1 : 0)
                                .animation(.spring(response: 1.2, dampingFraction: 0.6).delay(0.6), value: showWelcome)
                            
                            // Work in Progress Text
                            InfoSection(showWelcome: $showWelcome)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .opacity(showWelcome ? 1 : 0)
                                .offset(y: showWelcome ? 0 : 20)
                                .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(1.0), value: showWelcome)

                            // Animated Tools
                            AnimatedTool(animateTools: $animateTools, showWelcome: $showWelcome)
                                .padding(.top, 10)

                            // Coming Soon Features
                            GridCells(showWelcome: $showWelcome)
                                .padding(.horizontal, 30)
                                .opacity(showWelcome ? 1 : 0)
                                .offset(y: showWelcome ? 0 : 30)
                                .animation(.spring(response: 1.2, dampingFraction: 0.8).delay(1.6), value: showWelcome)
                            
                            
                            Spacer()
                            
                            // Logout Button
                            LogoutButton()
                                .padding(.horizontal, 30)
                                .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                                .opacity(showWelcome ? 1 : 0)
                                .scaleEffect(showWelcome ? 1 : 0.8)
                                .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(1.8), value: showWelcome)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                showWelcome = true
                animateConstruction = true
                animateTools = true
            }
            .onReceive(NotificationCenter.default.publisher(for: .userDidLogout)) { _ in
                isUserLoggedIn = false
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
