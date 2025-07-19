//
//  BreathingLogo.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI
import CoreMotion

struct BreathingLogo: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var gyroData: String = "Gyroscope Data"
    @State private var rotationAngle: Angle = .degrees(0)
    
    @Binding var isBreathing: Bool
    @Binding var showLogo: Bool
    
    private let motionManager = CMMotionManager()
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                // Outer breathing circle
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            .green.opacity(0.4),
                            .green.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 220, height: 220)
                    .scaleEffect(authViewModel.isBreathing ? 1.1 : 0.95)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: authViewModel.isBreathing)
                
                // Inner circle
                Circle()
                    .fill(.white.opacity(0.8))
                    .frame(width: 180, height: 180)
                    .scaleEffect(authViewModel.isBreathing ? 1.0 : 0.9)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: authViewModel.isBreathing)
                
                // Icon
                Image(systemName: "location.north.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(LinearGradient(
                        gradient: Gradient(colors: [.green, .blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                // .rotationEffect(.degrees(authViewModel.isBreathing ? 360 : 0))
                    .rotationEffect(rotationAngle)
                    .scaleEffect(authViewModel.isBreathing ? 1.1 : 0.95)
                    .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: authViewModel.isBreathing)
                    .onAppear{
                        startGyroUpdates()
                    }
                    .onDisappear{
                        stopGyroUpdates()
                    }
                    .animation(.linear(duration: 8.0).repeatForever(autoreverses: false), value: authViewModel.isBreathing)
                   
            }
            .opacity(showLogo ? 1 : 0)
            .scaleEffect(showLogo ? 1 : 0.3)
            .animation(.spring(response: 1.2, dampingFraction: 0.6, blendDuration: 0), value: showLogo)
        }
        
//        Text(gyroData)
//                      .font(.caption2)
//                      .foregroundStyle(.gray)
//                      .padding(.top, 8)
              
    }
    
    func startGyroUpdates() {
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: .main) { (data, error) in
                if let gyroData = data {
                    let x = gyroData.rotationRate.x
                    let y = gyroData.rotationRate.y
                    let z = gyroData.rotationRate.z
                    
                    // Update debug text
                    self.gyroData = String(format: "X: %.2f, Y: %.2f, Z: %.2f", x, y, z)
                    
                    // Apply rotation based on Y-axis (adjust multiplier as needed)
                    let deltaRotation = y * 5.0
                    self.rotationAngle += .degrees(deltaRotation)
                }
            }
        } else {
            self.gyroData = "Gyroscope not available"
        }
    }
    
    func stopGyroUpdates() {
        motionManager.stopGyroUpdates()
    }
}
