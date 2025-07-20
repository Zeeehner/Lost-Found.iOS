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
    
    @StateObject private var authViewModel = AuthViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            
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
            LoginView()
                .environmentObject(AuthViewModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
