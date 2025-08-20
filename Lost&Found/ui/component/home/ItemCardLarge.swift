//
//  ItemCardLarge.swift
//  Lost&Found
//
//  Created by Noah Ra on 03.09.25.
//

import SwiftUI


struct ItemCardLarge: View {
    
    let title: String
    let subtitle: String
    let image: Image
    let location: String
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            image
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipped()
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.green.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                .onTapGesture {
                    withAnimation {
                        isPressed.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isPressed.toggle()
                        }
                    }
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .foregroundStyle(.green)
                        .font(.system(size: 14))
                    Text(location)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.green.opacity(0.3), lineWidth: 2)
                )
        )
        .padding(.horizontal)
    }
}


#Preview {
    ItemCardLarge(title: "Adidas Ultraboost", subtitle: "Neuwertig", image: Image("keys") , location: "Düsseldorf")
}
