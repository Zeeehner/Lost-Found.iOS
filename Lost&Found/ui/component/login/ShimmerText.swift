//
//  ShimmerText.swift
//  Lost&Found
//
//  Created by Noah on 20.07.25.
//

import SwiftUI

struct ShimmerText: View {
    
    var text: String
    var font: Font
    var baseColors: [Color]
    var shimmerColor: Color = .white
    var shimmerWidth: CGFloat = 150
    var shimmerAngle: Double = 25

    @State private var shimmerOffset: CGFloat = -300

    var body: some View {
        
        let shimmer = LinearGradient(
            colors: [.clear, shimmerColor.opacity(0.8), .clear],
            startPoint: .top,
            endPoint: .bottom
        )

        ZStack {
            ZStack {
                LinearGradient(
                    colors: baseColors,
                    startPoint: .leading,
                    endPoint: .trailing
                )

                Rectangle()
                    .fill(shimmer)
                    .frame(width: shimmerWidth, height: 40)
                    .rotationEffect(.degrees(shimmerAngle))
                    .offset(x: shimmerOffset)
                    .blendMode(.screen)
            }
            .mask(
                Text(text)
                    .font(font)
                    .kerning(1.2)
            )
        }
        .onAppear {
            withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: false)) {
                shimmerOffset = 500
            }
        }
    }
}

