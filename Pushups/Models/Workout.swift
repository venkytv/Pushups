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
        Workout(sets: [10, 12, 7, 7, 9], rest: 60, day: 1),
        Workout(sets: [10, 12, 8, 8, 12], rest: 60, day: 2),
        Workout(sets: [11, 15, 9, 9, 13], rest: 60, day: 3),
        
        // Week 2
        Workout(sets: [14, 14, 10, 10, 15], rest: 60, day: 4),
        Workout(sets: [14, 16, 12, 12, 17], rest: 90, day: 5),
        Workout(sets: [16, 17, 14, 14, 20], rest: 120, day: 6),
        
        // Week 3
        Workout(sets: [14, 18, 14, 14, 20], rest: 60, day: 7),
        Workout(sets: [20, 25, 15, 15, 25], rest: 90, day: 8),
        Workout(sets: [22, 30, 20, 20, 28], rest: 120, day: 9),
        
        // Week 4
        Workout(sets: [21, 25, 21, 21, 32], rest: 60, day: 10),
        Workout(sets: [25, 29, 25, 25, 36], rest: 90, day: 11),
        Workout(sets: [29, 33, 29, 29, 40], rest: 120, day: 12),
        
        // Week 5
        Workout(sets: [36, 40, 30, 24, 40], rest: 60, day: 13),
        Workout(sets: [19, 19, 22, 22, 18, 18, 22, 45], rest: 45, day: 14),
        Workout(sets: [20, 20, 24, 24, 20, 20, 22, 50], rest: 45, day: 15),
        
        // Week 6
        Workout(sets: [45, 55, 35, 30, 55], rest: 60, day: 16),
        Workout(sets: [22, 22, 30, 30, 24, 24, 18, 18, 58], rest: 45, day: 17),
        Workout(sets: [26, 26, 33, 33, 26, 26, 22, 22, 60], rest: 45, day: 18),
    ]
    
    static var sampleData: Workout {
        workoutDays[2]
    }
    
    var repr: String {
        sets.map { String($0) }.joined(separator: " - ")
    }
}
