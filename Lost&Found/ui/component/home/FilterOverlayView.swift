//
//  FilterOverlayView.swift
//  Lost&Found
//
//  Created by Noah Ra on 03.09.25.
//

import SwiftUI

struct FilterOverlayView: View {
    
    @Binding var showLargeCards: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Filter")
                    .font(.headline)
                Spacer()
                Button(action: {
                    // Schließen-Button
                }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(.secondary)
                }
            }
            
            Toggle("Große ItemCards anzeigen", isOn: $showLargeCards)
            Toggle("Nur verlorene Gegenstände", isOn: .constant(true))
            Toggle("Nur gefundene Gegenstände", isOn: .constant(false))
            
            Button(role: .destructive) {
                // Suchverlauf löschen
            } label: {
                Text("Suchverlauf löschen")
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {
    FilterOverlayView(showLargeCards: .constant(true))
}
