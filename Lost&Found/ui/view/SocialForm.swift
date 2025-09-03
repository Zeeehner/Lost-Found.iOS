//
//  SocialForm.swift
//  Lost&Found
//
//  Created by Noah Ra on 03.09.25.
//

import SwiftUI

struct SocialForm: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Binding var text: String
    @Binding var searchText: String
    @Binding var isExpanding: Bool
    
    @State private var isHiding: Bool = true
    @State private var showFilterOverlay: Bool = false
    @State private var showLargeCards: Bool = true
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .trailing) {
                HStack(alignment: .top , spacing: 4) {
                    if !isHiding {
                        CustomTextField(
                            text: $searchText,
                            contentDescription: "Search for your hunts...",
                            icon: "magnifyingglass",
                            isSecure: false
                        )
                        .environmentObject(authViewModel)
                    }
                }
                
                // Beispielhafte ItemCards
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(0..<5) { i in
                            if showLargeCards {
                                ItemCardLarge(
                                    title: "Item \(i)",
                                    subtitle: "Beschreibung",
                                    image: Image("keys"),
                                    location: "Düsseldorf"
                                )
                            } else {
                                LazyHStack {
                                    ForEach(0..<2) { _ in
                                        ItemCardSmall(title: "Item \(i)", image: Image("Shoes"))
                                        
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.all)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isExpanding.toggle()
                        isHiding.toggle()
                    }) {
                        VStack {
                            Image(systemName: isExpanding ? "chevron.compact.up" : "chevron.compact.down")
                                .foregroundStyle(.green)
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(text.isEmpty ? .clear : .green.opacity(0.3), lineWidth: 2)
                                )
                        )
                    }
                }
            }
            
            // Floating Button für Filter
            Button(action: { showFilterOverlay.toggle() }) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Circle().fill(.green))
                    .shadow(radius: 4)
            }
            .padding()
            
            ZStack {
                if showFilterOverlay {
                    Color.black.opacity(0.3) // Dimmed Background
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation { showFilterOverlay = false } }
                    
                    VStack {
                        Spacer()
                        FilterOverlayView(showLargeCards: $showLargeCards)
                            .transition(.move(edge: .trailing))
                            .padding()
                    }
                }
            }
        }
    }
}


#Preview {
    SocialForm(
        text: .constant("Search for your goods..."),
        searchText: .constant("Search"),
        isExpanding: .constant(false)
    )
    .environmentObject(AuthViewModel())
}



