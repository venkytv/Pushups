//
//  Workout.swift
//  Pushups
//
//  Created by Venky Tumkur on 19/06/2022.
//

import Foundation

struct Workout: Codable {
    var sets: [Int]
    var rest: Int
    var day: Int
    
    init(sets: [Int], rest: Int, day: Int) {
        self.day = day
        self.sets = sets
        self.rest = rest
    }
    
    init(forDay day: Int) {
        self.day = day
        (self.sets, self.rest) = Workout.setsAndRestforDay(day: day)
    }
    
    static func setsAndRestforDay(day: Int) -> ([Int], Int) {
        if day < Workout.workoutDays.count {
            let workout = Workout.workoutDays[day]
            return (workout.sets, workout.rest)
        }
        
        guard let lastWorkout = workoutDays.last else {
            return ([100], 0)
        }
        
        let incrementWeeks: Int = 4 // Number of weeks for each increment of pushup count
        let increment = Int((day - Workout.workoutDays.count) / (3 * incrementWeeks))
        
        return (lastWorkout.sets.map { $0 + increment}, lastWorkout.rest)
    }
    
    func nextWorkout() -> Workout {
        return Workout(forDay: day + 1)
    }
    
    func previousWorkout() -> Workout? {
        if day <= 1 {
            return nil
        }
        return Workout(forDay: day - 1)
    }
    
    static let workoutDays: [Workout] = [
        // Zero-index
        Workout(sets: [100], rest: 0, day: 0),
        
        // Week 1
        Workout(sets: [10, 12, 13], rest: 60, day: 1),
        Workout(sets: [12, 13, 14], rest: 90, day: 2),
    ]
    
    static var sampleData: Workout {
        workoutDays[2]
    }
    
    var repr: String {
        sets.map { String($0) }.joined(separator: " - ")
    }
}
