//
//  Lost_FoundApp.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import SwiftUI
import SwiftData

@main
struct Lost_FoundApp: App {
    
    @StateObject private var authViewModel = AuthViewModel.shared
    @State private var split: Bool = false
    @State private var isBreaking: Bool = false
    @State private var showLogo: Bool = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            // Hier später deine Models rein
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if split {
                    LoginView()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .environmentObject(authViewModel)
                } else {
                    SplashView(
                        split: $split,
                        isBreaking: $isBreaking,
                        showLogo: $showLogo,
                        onFinish: {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                split = true
                            }
                        }
                    )
                }
            }
            .modelContainer(sharedModelContainer)
        }
    }
}
