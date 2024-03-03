//
//  ProjectTrackerApp.swift
//  ProjectTracker
//
//  Created by Arcticulate on 2024-02-11.
//

import SwiftUI

@main
struct ProjectTrackerApp: App {
    @State private var model: Tracker = Tracker()
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: $model)
        }
    }
}
