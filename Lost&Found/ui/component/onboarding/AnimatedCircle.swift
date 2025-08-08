//
//  AnimatedCircle.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct AnimatedCircle: View {
    
    @Binding var animateConstruction: Bool
    
    var body: some View {
        VStack(spacing: 25) {
            // Construction Icon
            ZStack {
                // Background Circle
                Circle()
                    .fill(LinearGradient(
                        colors: [.orange.opacity(0.3), .yellow.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 180, height: 180)
                    .scaleEffect(animateConstruction ? 1.1 : 0.9)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateConstruction)
                
                // Construction Hat
                Image(systemName: "hammer.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(LinearGradient(
                        colors: [.orange, .yellow],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .rotationEffect(.degrees(animateConstruction ? 15 : -15))
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateConstruction)
            }
        }
    }
}
