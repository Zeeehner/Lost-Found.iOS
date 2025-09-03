//
//  ItemCardSmall.swift
//  Lost&Found
//
//  Created by Noah Ra on 03.09.25.
//

import SwiftUI

struct ItemCardSmall: View {
    let title: String
    let image: Image
    
    @State private var isHovered = false

    var body: some View {
        VStack(spacing: 8) {
            image
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 120)
                .clipped()
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.green.opacity(isHovered ? 0.6 : 0.3), lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

            Text(title)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.green.opacity(isHovered ? 0.4 : 0.2), lineWidth: 2)
                )
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onHover { hovering in
            withAnimation {
                isHovered = hovering
            }
        }
    }
}

#Preview {
    ItemCardSmall(title: "Nike Air z270", image: Image("shoes"))
}


