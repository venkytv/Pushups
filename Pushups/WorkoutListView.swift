//
//  WorkoutListView.swift
//  Pushups
//
//  Created by Venky Tumkur on 19/06/2022.
//

import SwiftUI

struct WorkoutListView: View {
    @EnvironmentObject var store: WorkoutStore
    @Environment(\.scenePhase) private var scenePhase
    
    let saveAction: ()->Void

    var body: some View {
        List {
            let workout = store.currentWorkout
            let theme = Theme.orange
            NavigationLink(destination: PushupView(workout: workout, theme: theme)) {
                CardView(workout: workout)
            }
            
            let nextWorkout = store.currentWorkout.nextWorkout()
            let nextTheme = Theme.poppy
            NavigationLink(destination: PushupView(workout: nextWorkout, theme: nextTheme)) {
                CardView(workout: nextWorkout)
            }
            
            if let previousWorkout = store.currentWorkout.previousWorkout() {
                let previousTheme = Theme.seafoam
                NavigationLink(destination: PushupView(workout: previousWorkout, theme: previousTheme)) {
                    CardView(workout: previousWorkout)
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        let store: WorkoutStore = WorkoutStore()
        NavigationView {
            WorkoutListView(saveAction: {})
        }
        .environmentObject(store)
    }
}
