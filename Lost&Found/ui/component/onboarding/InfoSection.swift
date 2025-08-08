//
//  InfoSection.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct InfoSection: View {
    
    @Binding var showWelcome: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Text("🚧 Under Construction 🚧")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.orange)
                .multilineTextAlignment(.center)
                .opacity(showWelcome ? 1 : 0)
                .offset(y: showWelcome ? 0 : 20)
                .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.8), value: showWelcome)
            
            Text("The App is still in development.")
            Text("Soon you will be able to explore all the features!")
        }
    }
}
