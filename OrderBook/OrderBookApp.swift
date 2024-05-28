//
//  OrderBookApp.swift
//  OrderBook
//
//  Created by rajasekar.r on 20/04/24.
//

import SwiftUI
import SwiftData

@main
struct OrderBookApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PurchaseList.self,
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
            PurchaseListHomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
