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
                WorkoutListView() {
                    WorkoutStore.save(workout: store.currentWorkout) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
            }
            .onAppear {
                WorkoutStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let workout):
                        store.currentWorkout = workout
                    }
                }
            }
            .environmentObject(store)
        }
    }
}
