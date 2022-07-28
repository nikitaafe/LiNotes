//
//  LiNotesApp.swift
//  LiNotes
//
//  Created by Nikita Felicia on 20/07/22.
//

import SwiftUI

@main
struct LiNotesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
