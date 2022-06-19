//
//  WorkoutStore.swift
//  Pushups
//
//  Created by Venky Tumkur on 19/06/2022.
//

import Foundation

class WorkoutStore: ObservableObject {
    @Published var currentWorkout: Workout = Workout.sampleData
}
