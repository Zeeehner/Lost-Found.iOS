//
//  SplashView.swift
//  Lost&Found
//
//  Created by Noah on 20.08.25.
//

import SwiftUI

struct SplashView: View {

    @Binding var split: Bool
    @Binding var isBreaking: Bool
    @Binding var showLogo: Bool
    
    var onFinish: (() -> Void)? = nil // wird aufgerufen, wenn alle Animationen fertig sind
    
    @State private var animationTime: Double = 0
    @State private var isCompleted: Bool = false
    @State private var useBreathingLogoVariant: Bool = true // Toggle zwischen Varianten
    
    // Animation states for compass parts - von weiter weg
    @State private var outerFrameOffset: CGSize = CGSize(width: -600, height: 0)
    @State private var innerFrameOffset: CGSize = CGSize(width: 600, height: 0)
    @State private var faceOffset: CGSize = CGSize(width: 0, height: -600)
    @State private var needleOffset: CGSize = CGSize(width: 0, height: 600)
    @State private var centerCapOffset: CGSize = CGSize(width: 400, height: -400)
    @State private var glassOffset: CGSize = CGSize(width: -400, height: 400)
    
    // Rotation states - mehr Rotation
    @State private var outerFrameRotation: Double = 1080
    @State private var innerFrameRotation: Double = -1080
    @State private var faceRotation: Double = 720
    @State private var needleRotation: Double = -720
    @State private var centerCapRotation: Double = 900
    @State private var glassRotation: Double = -900
    
    // Scale states
    @State private var outerFrameScale: CGFloat = 0.3
    @State private var innerFrameScale: CGFloat = 0.3
    @State private var faceScale: CGFloat = 0.3
    @State private var needleScale: CGFloat = 0.3
    @State private var centerCapScale: CGFloat = 0.3
    @State private var glassScale: CGFloat = 0.3
    
    // Opacity states
    @State private var outerFrameOpacity: Double = 0
    @State private var innerFrameOpacity: Double = 0
    @State private var faceOpacity: Double = 0
    @State private var needleOpacity: Double = 0
    @State private var centerCapOpacity: Double = 0
    @State private var glassOpacity: Double = 0
    
    // Final compass animation
    @State private var finalCompassScale: CGFloat = 0.8
    @State private var finalCompassOpacity: Double = 0
    
    // App title animation
    @State private var appTitleOpacity: Double = 0
    @State private var appTitleOffset: CGFloat = 50
    
    // Breathing Logo Animation States
    @State private var isBreathing: Bool = false
    @State private var showBreathingLogo: Bool = false
    @State private var ripple: Bool = false
    
    // Paperplane Animation States
    @State private var paperplaneOffset: CGSize = CGSize(width: 0, height: 800)
    @State private var paperplaneRotation: Double = 0
    @State private var paperplaneScale: CGFloat = 1.0
    @State private var paperplaneOpacity: Double = 1.0
    @State private var paperplaneFlying: Bool = false
    @State private var paperplaneCaught: Bool = false
    
    // Ring catching animation states
    @State private var outerCircleOffset: CGSize = CGSize(width: -400, height: 0)
    @State private var innerCircleOffset: CGSize = CGSize(width: 400, height: 0)
    @State private var rippleOffset: CGSize = CGSize(width: 0, height: -400)
    
    @State private var outerCircleRotation: Double = 720
    @State private var innerCircleRotation: Double = -720
    @State private var rippleRotation: Double = 540
    
    @State private var outerCircleScale: CGFloat = 0.2
    @State private var innerCircleScale: CGFloat = 0.2
    @State private var rippleScale: CGFloat = 0.2
    
    @State private var outerCircleOpacity: Double = 0
    @State private var innerCircleOpacity: Double = 0
    @State private var rippleOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background
            GradientBackround()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Spacer()
                
                if useBreathingLogoVariant {
                    // Breathing Logo Variant mit Paperplane
                    breathingLogoWithPaperplaneVariant
                } else {
                    // Original Compass Variant
                    compassVariant
                }
                
                // App Title
                VStack(spacing: 8) {
                    Text("Lost & Found")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .teal, .blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(appTitleOpacity)
                        .offset(y: appTitleOffset)
                }
                
                Spacer()
            }
        }
        .onAppear {
            if useBreathingLogoVariant {
                startPaperplaneAnimation()
            } else {
                startCompassAnimation()
            }
        }
    }
    
    // MARK: - Breathing Logo mit Paperplane Variant
    private var breathingLogoWithPaperplaneVariant: some View {
        ZStack {
            // Paperplane
            Image(systemName: "paperplane.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.green, .blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .offset(paperplaneOffset)
                .rotationEffect(.degrees(paperplaneRotation))
                .scaleEffect(paperplaneScale)
                .opacity(paperplaneOpacity)
                .shadow(color: .green.opacity(0.5), radius: 10, x: 0, y: 5)
            
            // Animated Rings
            ZStack {
                // Outer Circle
                BreathingLogoPartView(
                    content: outerCircleView,
                    offset: outerCircleOffset,
                    rotation: outerCircleRotation,
                    scale: outerCircleScale,
                    opacity: outerCircleOpacity
                )
                
                // Inner Circle
                BreathingLogoPartView(
                    content: innerCircleView,
                    offset: innerCircleOffset,
                    rotation: innerCircleRotation,
                    scale: innerCircleScale,
                    opacity: innerCircleOpacity
                )
                
                // Ripple Effect
                BreathingLogoPartView(
                    content: rippleView,
                    offset: rippleOffset,
                    rotation: rippleRotation,
                    scale: rippleScale,
                    opacity: rippleOpacity
                )
            }
            
            // Final assembled breathing logo
            BreathingLogo(isBreathing: $isBreathing, showLogo: $showBreathingLogo)
                .scaleEffect(finalCompassScale)
                .opacity(finalCompassOpacity)
        }
    }
    
    // MARK: - Compass Variant
    private var compassVariant: some View {
        ZStack {
            // Animated Compass Parts
            ZStack {
                // Outer Frame
                CompassPartView(
                    content: outerFrameView,
                    offset: outerFrameOffset,
                    rotation: outerFrameRotation,
                    scale: outerFrameScale,
                    opacity: outerFrameOpacity
                )
                
                // Inner Frame
                CompassPartView(
                    content: innerFrameView,
                    offset: innerFrameOffset,
                    rotation: innerFrameRotation,
                    scale: innerFrameScale,
                    opacity: innerFrameOpacity
                )
                
                // Face
                CompassPartView(
                    content: faceView,
                    offset: faceOffset,
                    rotation: faceRotation,
                    scale: faceScale,
                    opacity: faceOpacity
                )
                
                // Needle
                CompassPartView(
                    content: needleView,
                    offset: needleOffset,
                    rotation: needleRotation,
                    scale: needleScale,
                    opacity: needleOpacity
                )
                
                // Center Cap
                CompassPartView(
                    content: centerCapView,
                    offset: centerCapOffset,
                    rotation: centerCapRotation,
                    scale: centerCapScale,
                    opacity: centerCapOpacity
                )
                
                // Glass Overlay
                CompassPartView(
                    content: glassOverlayView,
                    offset: glassOffset,
                    rotation: glassRotation,
                    scale: glassScale,
                    opacity: glassOpacity
                )
            }
        }
    }
    
    // MARK: - Paperplane Animation Methods
    private func startPaperplaneAnimation() {
        // Start paperplane flying from bottom
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 2.0)) {
                paperplaneOffset = CGSize(width: 0, height: -100)
                paperplaneRotation = 360
                paperplaneFlying = true
            }
        }
        
        // After 2 seconds, start catching animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            // Paperplane gets caught
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                paperplaneOffset = .zero
                paperplaneRotation = 0
                paperplaneScale = 0.8
                paperplaneCaught = true
            }
            
            // Start ring catching sequence
            animateRingCatching()
        }
        
        // Show final breathing logo after catching
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                finalCompassScale = 1.0
                finalCompassOpacity = 1.0
                showBreathingLogo = true
                isBreathing = true
                ripple = true
            }
            
            // Show app title
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 1.0, dampingFraction: 0.7)) {
                    appTitleOpacity = 1.0
                    appTitleOffset = 0
                }
            }
            
            // Mark as completed after total animation time
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isCompleted = true
                onFinish?() // finishing animation 
            }
        }
    }
    
    private func animateRingCatching() {
        // Outer ring catches first
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                outerCircleOffset = .zero
                outerCircleRotation = 0
                outerCircleScale = 1.0
                outerCircleOpacity = 1.0
            }
        }
        
        // Inner ring catches second
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                innerCircleOffset = .zero
                innerCircleRotation = 0
                innerCircleScale = 1.0
                innerCircleOpacity = 1.0
            }
        }
        
        // Ripple effect catches last
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                rippleOffset = .zero
                rippleRotation = 0
                rippleScale = 1.0
                rippleOpacity = 1.0
            }
        }
    }
    
    // MARK: - Breathing Logo Animation Methods (old)
    private func startBreathingLogoAnimation() {
        // Start breathing animation
        isBreathing = true
        ripple = true
        
        // Animate parts flying in with delays
        animateBreathingPart(part: "outerCircle", delay: 0.0)
        animateBreathingPart(part: "innerCircle", delay: 0.3)
        animateBreathingPart(part: "locationIcon", delay: 0.6)
        animateBreathingPart(part: "ripple", delay: 0.9)
        
        // Show final breathing logo after all parts are assembled
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                finalCompassScale = 1.0
                finalCompassOpacity = 1.0
                showBreathingLogo = true
            }
            
            // Show app title
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 1.0, dampingFraction: 0.7)) {
                    appTitleOpacity = 1.0
                    appTitleOffset = 0
                }
            }
            
            // Mark as completed after total animation time
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isCompleted = true
            }
        }
    }
    
    private func animateBreathingPart(part: String, delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                switch part {
                case "outerCircle":
                    outerCircleOffset = .zero
                    outerCircleRotation = 0
                    outerCircleScale = 1.0
                    outerCircleOpacity = 1.0
                case "innerCircle":
                    innerCircleOffset = .zero
                    innerCircleRotation = 0
                    innerCircleScale = 1.0
                    innerCircleOpacity = 1.0
                case "ripple":
                    rippleOffset = .zero
                    rippleRotation = 0
                    rippleScale = 1.0
                    rippleOpacity = 1.0
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - Breathing Logo Part Views
    private func outerCircleView() -> some View {
        Circle()
            .fill(LinearGradient(
                gradient: Gradient(colors: [.green.opacity(0.4), .green.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing))
            .frame(width: 220, height: 220)
    }
    
    private func innerCircleView() -> some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.8))
                .frame(width: 180, height: 180)
            
            // Kompass-Markierungen
            Group {
                Text("N")
                    .font(.headline)
                    .foregroundStyle(.green)
                    .offset(y: -80)
                Text("S")
                    .font(.headline)
                    .foregroundStyle(.green)
                    .offset(y: 80)
                Text("O")
                    .font(.headline)
                    .foregroundStyle(.green)
                    .offset(x: 80)
                Text("W")
                    .font(.headline)
                    .foregroundStyle(.green)
                    .offset(x: -80)
            }
        }
    }
    
    private func locationIconView() -> some View {
        Image(systemName: "location.north.circle.fill")
            .font(.system(size: 80))
            .foregroundStyle(LinearGradient(
                gradient: Gradient(colors: [.green, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing))
    }
    
    private func rippleView() -> some View {
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
            }
        }
    }
    
    // MARK: - Compass Animation Methods
    private func startCompassAnimation() {
        // Start continuous needle rotation
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            animationTime += .pi * 2
        }
        
        // Animate parts flying in with delays
        animatePart(part: "outerFrame", delay: 0.0)
        animatePart(part: "innerFrame", delay: 0.3)
        animatePart(part: "face", delay: 0.6)
        animatePart(part: "needle", delay: 0.9)
        animatePart(part: "centerCap", delay: 1.2)
        animatePart(part: "glass", delay: 1.5)
        
        // Show final compass after all parts are assembled
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                finalCompassScale = 1.0
                finalCompassOpacity = 1.0
            }
            
            // Show app title
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 1.0, dampingFraction: 0.7)) {
                    appTitleOpacity = 1.0
                    appTitleOffset = 0
                }
            }
            
            // Mark as completed after total animation time
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isCompleted = true
            }
        }
    }
    
    private func animatePart(part: String, delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                switch part {
                case "outerFrame":
                    outerFrameOffset = .zero
                    outerFrameRotation = 0
                    outerFrameScale = 1.0
                    outerFrameOpacity = 1.0
                case "innerFrame":
                    innerFrameOffset = .zero
                    innerFrameRotation = 0
                    innerFrameScale = 1.0
                    innerFrameOpacity = 1.0
                case "face":
                    faceOffset = .zero
                    faceRotation = 0
                    faceScale = 1.0
                    faceOpacity = 1.0
                case "needle":
                    needleOffset = .zero
                    needleRotation = 0
                    needleScale = 1.0
                    needleOpacity = 1.0
                case "centerCap":
                    centerCapOffset = .zero
                    centerCapRotation = 0
                    centerCapScale = 1.0
                    centerCapOpacity = 1.0
                case "glass":
                    glassOffset = .zero
                    glassRotation = 0
                    glassScale = 1.0
                    glassOpacity = 1.0
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - Compass Part Views
    private func outerFrameView() -> some View {
        ZStack {
            Circle()
                .strokeBorder(
                    AngularGradient(gradient: Gradient(colors: [
                        Color(red: 0.82, green: 0.88, blue: 0.95),
                        Color(red: 0.78, green: 0.90, blue: 0.88),
                        Color(red: 0.92, green: 0.86, blue: 0.94),
                        Color(red: 0.82, green: 0.88, blue: 0.95)
                    ]), center: .center),
                    lineWidth: 22
                )
                .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 4)
            
            Circle()
                .stroke(.white.opacity(0.25), lineWidth: 1)
                .blur(radius: 0.6)
                .padding(8)
            
            Circle()
                .stroke(.black.opacity(0.06), lineWidth: 6)
                .padding(12)
        }
        .frame(width: 320, height: 320)
    }
    
    private func innerFrameView() -> some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(gradient: Gradient(colors: [
                        Color(red: 0.97, green: 0.95, blue: 0.98),
                        Color(red: 0.94, green: 0.98, blue: 0.96)
                    ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .overlay(
                    Circle()
                        .stroke(LinearGradient(gradient: Gradient(colors: [
                            Color.white.opacity(0.6),
                            Color.white.opacity(0.12)
                        ]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                        .blendMode(.screen)
                )
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
            
            Circle()
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
                .padding(20)
        }
        .frame(width: 270, height: 270)
    }
    
    private func faceView() -> some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(gradient: Gradient(colors: [
                        Color(red: 0.99, green: 0.98, blue: 0.95),
                        Color(red: 0.95, green: 0.99, blue: 0.97)
                    ]), center: .center, startRadius: 10, endRadius: 140)
                )
                .overlay(
                    Circle()
                        .fill(Color.white.opacity(0.02))
                        .blur(radius: 6)
                )
                .frame(width: 240, height: 240)
            
            ForEach(0..<36) { i in
                let angle = Double(i) * 10
                let isMajor = i % 3 == 0
                let isCardinal = i % 9 == 0
                Rectangle()
                    .fill(markColor(isCardinal: isCardinal, isMajor: isMajor))
                    .frame(width: isCardinal ? 3 : isMajor ? 2 : 1, height: isCardinal ? 20 : isMajor ? 12 : 6)
                    .offset(y: -110)
                    .rotationEffect(.degrees(angle))
                    .opacity(isCardinal ? 0.95 : 0.75)
            }
            
            Circle().stroke(Color.white.opacity(0.03), lineWidth: 1).frame(width: 180, height: 180)
            Circle().stroke(Color.black.opacity(0.03), lineWidth: 1).frame(width: 140, height: 140)
            
            Group {
                Text("N").cardinalStyle()
                    .offset(y: -88)
                Text("E").cardinalStyle()
                    .offset(x: 88)
                Text("S").cardinalStyle()
                    .offset(y: 88)
                Text("W").cardinalStyle()
                    .offset(x: -88)
            }
            .rotationEffect(.degrees(0))
        }
        .frame(width: 240, height: 240)
    }
    
    private func needleView() -> some View {
        ZStack {
            NeedleHalf(color: Color(red: 0.72, green: 0.88, blue: 0.95), inset: 6)
                .offset(y: -6)
            
            NeedleHalf(color: Color(red: 1.0, green: 0.75, blue: 0.78), inset: -6)
                .offset(y: 6)
            
            Capsule()
                .fill(Color.white.opacity(0.9))
                .frame(width: 6, height: 160)
                .blendMode(.screen)
                .opacity(0.9)
                .shadow(color: Color.white.opacity(0.25), radius: 6, x: 0, y: 0)
        }
        .frame(width: 24, height: 260)
        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
        .offset(y: -6)
    }
    
    private func centerCapView() -> some View {
        Circle()
            .fill(
                RadialGradient(gradient: Gradient(colors: [
                    Color(red: 1.0, green: 0.95, blue: 0.88),
                    Color(red: 1.0, green: 0.88, blue: 0.75)
                ]), center: .center, startRadius: 1, endRadius: 12)
            )
            .frame(width: 28, height: 28)
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
                    .blur(radius: 0.2)
            )
            .shadow(color: Color.black.opacity(0.16), radius: 6, x: 0, y: 3)
    }
    
    private func glassOverlayView() -> some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(gradient: Gradient(stops: [
                        .init(color: Color.white.opacity(0.18), location: 0.0),
                        .init(color: Color.white.opacity(0.06), location: 0.25),
                        .init(color: Color.white.opacity(0.0), location: 0.6)
                    ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .blendMode(.overlay)
                .frame(width: 240, height: 240)
                .mask(
                    Circle()
                        .frame(width: 240, height: 240)
                )
            
            Capsule()
                .fill(Color.white.opacity(0.08))
                .frame(width: 160, height: 22)
                .rotationEffect(.degrees(-28))
                .offset(x: -40, y: -60)
                .blur(radius: 4)
        }
        .allowsHitTesting(false)
    }
    
    private func markColor(isCardinal: Bool, isMajor: Bool) -> Color {
        if isCardinal {
            return Color(red: 1.0, green: 0.82, blue: 0.82)
        } else if isMajor {
            return Color(red: 0.85, green: 0.85, blue: 0.9)
        } else {
            return Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.9)
        }
    }
}

// MARK: - Compass Part View Wrapper
struct CompassPartView<Content: View>: View {
    let content: () -> Content
    let offset: CGSize
    let rotation: Double
    let scale: CGFloat
    let opacity: Double
    
    var body: some View {
        content()
            .offset(offset)
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .opacity(opacity)
    }
}

// MARK: - Breathing Logo Part View Wrapper
struct BreathingLogoPartView<Content: View>: View {
    let content: () -> Content
    let offset: CGSize
    let rotation: Double
    let scale: CGFloat
    let opacity: Double
    
    var body: some View {
        content()
            .offset(offset)
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .opacity(opacity)
    }
}

// MARK: - Needle Half
struct NeedleHalf: View {
    var color: Color
    var inset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            Path { p in
                p.move(to: CGPoint(x: w/2, y: 0))
                p.addLine(to: CGPoint(x: w, y: h*0.6))
                p.addQuadCurve(to: CGPoint(x: 0, y: h*0.6), control: CGPoint(x: w/2, y: h*0.8))
                p.closeSubpath()
            }
            .fill(
                LinearGradient(gradient: Gradient(colors: [
                    color.opacity(0.98),
                    color.opacity(0.75),
                    Color.white.opacity(0.12)
                ]), startPoint: .top, endPoint: .bottom)
            )
            .overlay(
                Path { p in
                    p.move(to: CGPoint(x: w/2, y: 0))
                    p.addLine(to: CGPoint(x: w, y: h*0.6))
                }
                .stroke(Color.white.opacity(0.35), lineWidth: 0.8)
                .blendMode(.screen)
            )
        }
        .frame(width: 160, height: 160)
        .scaleEffect(0.9)
    }
}

// MARK: - Cardinal Style Extension
extension Text {
    func cardinalStyle() -> some View {
        self.font(.system(size: 20, weight: .semibold, design: .rounded))
            .foregroundColor(Color(red: 1.0, green: 0.7, blue: 0.7))
            .shadow(color: Color.white.opacity(0.3), radius: 0.5, x: 0, y: 1)
    }
}
