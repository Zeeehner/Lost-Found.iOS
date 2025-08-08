//
//  BreathingLogo.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI
import CoreLocation

struct BreathingLogo: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @StateObject private var compassVM = CompassViewModel()
    
    @Binding var isBreathing: Bool
    @Binding var showLogo: Bool
    
    @State private var ripple = false
    
    var body: some View {
        ZStack {
            // MARK: - Radarwellen zentriert via Overlay
            Color.clear
                .frame(width: 220, height: 220)
                .overlay(
                    ZStack {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .stroke(
                                    LinearGradient(colors: [.green.opacity(0.6), .clear],
                                                   startPoint: .top,
                                                   endPoint: .bottom),
                                    lineWidth: 3
                                )
                                .frame(width: CGFloat(150 + index * 60),
                                       height: CGFloat(150 + index * 60))
                                .scaleEffect(ripple ? 1.6 : 0.7)
                                .opacity(ripple ? 0.0 : 0.5)
                                .animation(
                                    Animation.easeOut(duration: 3)
                                        .repeatForever()
                                        .delay(Double(index) * 0.5), value: ripple
                                )
                        }
                    }
                        .allowsHitTesting(false)
                        .drawingGroup()
                        .onAppear { ripple = true }
                )
            
            // MARK: - Logo
            VStack(spacing: 20) {
                ZStack {
                    // Outer breathing circle
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.green.opacity(0.4), .green.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing))
                        .frame(width: 220, height: 220)
                        .scaleEffect(isBreathing ? 1.1 : 0.95)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isBreathing)
                    
                    // Inner circle mit Kompass-Richtungen (N, S, O, W)
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.8))
                            .frame(width: 180, height: 180)
                            .scaleEffect(isBreathing ? 1.0 : 0.9)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isBreathing)
                        
                        // Kompass-Markierungen
                        Group {
                            Text("N")
                                .font(.headline)
                                .foregroundColor(.green)
                                .offset(y: -80)
                            Text("S")
                                .font(.headline)
                                .foregroundColor(.green)
                                .offset(y: 80)
                            Text("O")
                                .font(.headline)
                                .foregroundColor(.green)
                                .offset(x: 80)
                            Text("W")
                                .font(.headline)
                                .foregroundColor(.green)
                                .offset(x: -80)
                        }
                        .rotationEffect(.degrees(compassVM.heading))
                        .animation(.easeInOut, value: compassVM.heading)
                    }
                    
                    // Standort-Symbol, das immer nach Norden zeigt (gegen den Kompass drehen)
                    Image(systemName: "location.north.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(LinearGradient(
                            gradient: Gradient(colors: [.green, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing))
                        .rotationEffect(.degrees(-compassVM.heading))
                        .scaleEffect(isBreathing ? 1.1 : 0.95)
                        .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isBreathing)
                }
                .opacity(showLogo ? 1 : 0)
                .scaleEffect(showLogo ? 1 : 0.3)
                .animation(.spring(response: 1.2, dampingFraction: 0.6), value: showLogo)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
    }
}
