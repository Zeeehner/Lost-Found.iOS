//
//  GridCells.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct GridCells: View {
    
    @Binding var showWelcome: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Upcoming features:")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.primary)
                .opacity(showWelcome ? 1 : 0)
                .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(1.4), value: showWelcome)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
            
                FeatureCard(icon: "magnifyingglass.circle.fill", title: "Search", color: .blue)
                FeatureCard(icon: "plus.circle.fill", title: "Post", color: .green)
                FeatureCard(icon: "map.fill", title: "Maps", color: .red)
                FeatureCard(icon: "bell.fill", title: "Notifications", color: .purple)
            }
        }
    }
}

#Preview {
    GridCells(showWelcome: .constant(true))
}
