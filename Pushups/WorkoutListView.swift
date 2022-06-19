//
//  WorkoutListView.swift
//  Pushups
//
//  Created by Venky Tumkur on 19/06/2022.
//

import SwiftUI

struct WorkoutListView: View {
    @EnvironmentObject var store: WorkoutStore
    @State private var workout: Workout = Workout(sets: [100], rest: 0, day: 0)
    
    private var nextWorkout: Workout {
        workout.nextWorkout()
    }
    
    var body: some View {
        List {
            NavigationLink(destination: PushupView(workout: workout)) {
                CardView(workout: workout)
            }
            
            NavigationLink(destination: PushupView(workout: nextWorkout)) {
                CardView(workout: nextWorkout)
            }
            
            if let previousWorkout = workout.previousWorkout() {
                NavigationLink(destination: PushupView(workout: previousWorkout)) {
                    CardView(workout: previousWorkout)
                }
            }
        }
        .onAppear {
            workout = store.currentWorkout
        }
    }
}

struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        let store: WorkoutStore = WorkoutStore()
        NavigationView {
            WorkoutListView()
        }
        .environmentObject(store)
    }
}
