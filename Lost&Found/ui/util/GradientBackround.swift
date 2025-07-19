//
//  GradientBackround.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI

struct GradientBackround: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                .green.opacity(0.1),
                .blue.opacity(0.05),
                .white
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    GradientBackround()
}
