//
//  PushupsApp.swift
//  Pushups
//
//  Created by Venky Tumkur on 19/06/2022.
//

import SwiftUI

@main
struct PushupsApp: App {
    @StateObject private var store: WorkoutStore = WorkoutStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                WorkoutListView()
            }
            .environmentObject(store)
        }
    }
}
