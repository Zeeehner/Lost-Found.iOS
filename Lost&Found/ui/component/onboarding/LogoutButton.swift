//
//  LogoutButton.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct LogoutButton: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var showingConfirmation = false
    @State private var isLoggingOut = false
    
    var body: some View {
        Button(action: {
            showingConfirmation = true
        }) {
            HStack {
                if isLoggingOut {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(isLoggingOut ? "Abmelden..." : "Abmelden")
                    .font(.system(size: 16, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: isLoggingOut ?
                    [.gray.opacity(0.6), .gray.opacity(0.4)] :
                        [.red.opacity(0.8), .orange.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundStyle(.white)
            .cornerRadius(12)
            .shadow(
                color: isLoggingOut ? .gray.opacity(0.2) : .red.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
            .scaleEffect(isLoggingOut ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isLoggingOut)
        }
        .disabled(isLoggingOut || authViewModel.isLoading)
        .confirmationDialog(
            "Abmelden bestätigen",
            isPresented: $showingConfirmation,
            titleVisibility: .visible
        ) {
            Button("Abmelden", role: .destructive) {
                Task {
                    isLoggingOut = true
                    await authViewModel.logout()
                    isLoggingOut = false
                }
            }
            Button("Abbrechen", role: .cancel) { }
        } message: {
            Text("Möchten Sie sich wirklich abmelden?")
        }
    }
}
