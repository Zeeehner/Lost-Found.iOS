//
//  FilterSheetView.swift
//  Lost&Found
//
//  Created by Noah Ra on 03.09.25.
//

import SwiftUI

struct FilterSheetView: View {
    @Binding var showLargeCards: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Darstellung")) {
                    Toggle("Große ItemCards anzeigen", isOn: $showLargeCards)
                }
                
                Section(header: Text("Filter")) {
                    Toggle("Nur verlorene Gegenstände", isOn: .constant(true))
                    Toggle("Nur gefundene Gegenstände", isOn: .constant(false))
                }
                
                Section {
                    Button(role: .destructive) {
                        // Suchverlauf löschen
                    } label: {
                        Text("Suchverlauf löschen")
                    }
                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FilterSheetView(showLargeCards: .constant(false))
}
