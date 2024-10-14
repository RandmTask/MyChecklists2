//
//  MyChecklistsApp.swift
//  MyChecklists
//
//  Created by Deon O'Brien on 14/10/24.
//


import SwiftUI
import SwiftData

@main
struct MyChecklistsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Checklist.self)
    }
}
