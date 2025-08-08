//
//  AnimatedTool.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct AnimatedTool: View {
    
    @Binding var animateTools: Bool
    @Binding var showWelcome: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                ForEach(Array(["wrench.fill", "screwdriver.fill", "paintbrush.fill"].enumerated()), id: \.offset) { index, icon in
                    Image(systemName: icon)
                        .font(.system(size: 30))
                        .foregroundStyle(LinearGradient(
                            colors: [.orange, .yellow],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .rotationEffect(.degrees(animateTools ? 360 : 0))
                        .animation(.linear(duration: 3.0 + Double(index)).repeatForever(autoreverses: false), value: animateTools)
                        .scaleEffect(animateTools ? 1.2 : 0.8)
                        .animation(.easeInOut(duration: 1.0 + Double(index) * 0.2).repeatForever(autoreverses: true), value: animateTools)
                        .opacity(showWelcome ? 1 : 0)
                        .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(1.2 + Double(index) * 0.1), value: showWelcome)
                }
            }
        }
    }
}
