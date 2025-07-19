//
//  Branding.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct Branding: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Binding var showLogo: Bool
    
    var body: some View {
        Text("Lost & Found")
            .font(.system(size: 32, weight: .heavy, design: .rounded))
            .foregroundStyle(LinearGradient(
                gradient: Gradient(colors: [.primary, .green]),
                startPoint: .leading,
                endPoint: .trailing
            ))
            .opacity(showLogo ? 1 : 0)
            .offset(y: showLogo ? 0 : 30)
            .animation(.spring(response: 1.0, dampingFraction: 0.8, blendDuration: 0).delay(0.3), value: showLogo)
    }
}

#Preview {
    Branding(showLogo: .constant(true))
}
