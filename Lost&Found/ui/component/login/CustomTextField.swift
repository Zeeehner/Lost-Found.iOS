//
//  CustomTextField.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct CustomTextField: View {
    
    @State private var isSecureVisible = true
    
    @Binding var text: String
    
    let contentDescription: String
    let icon: String
    let isSecure: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(.green)
                .frame(width: 20)
            
            if isSecure && isSecureVisible {
                SecureField(contentDescription, text: $text)
                    .font(.system(size: 16))
            } else {
                TextField(contentDescription, text: $text)
                    .font(.system(size: 16))
            }
            
            if isSecure {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSecureVisible.toggle()
                    }
                }) {
                    Image(systemName: isSecureVisible ? "eye.slash" : "eye")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray.opacity(0.5))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(text.isEmpty ? .clear : .green.opacity(0.3), lineWidth: 2)))
        .autocapitalization(.none)
        .disableAutocorrection(true)
    }
}
