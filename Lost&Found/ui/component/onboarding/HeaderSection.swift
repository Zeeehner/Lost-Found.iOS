//
//  HeaderSection.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct HeaderSection: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Binding var showWelcome: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Welcome back!")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(LinearGradient(
                    colors: [.primary, .orange],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .opacity(showWelcome ? 1 : 0)
                .offset(y: showWelcome ? 0 : -20)
                .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.2), value: showWelcome)
            
            Text("Hello, \(authViewModel.user?.username ?? "User")!")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.secondary)
                .opacity(showWelcome ? 1 : 0)
                .offset(y: showWelcome ? 0 : -15)
                .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.4), value: showWelcome)
        }
    }
}

#Preview {
    HeaderSection(showWelcome: .constant(true))
        .environmentObject(AuthViewModel())
}
