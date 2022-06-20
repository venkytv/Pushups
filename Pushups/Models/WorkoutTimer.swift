//
//  WorkoutTimer.swift
//  Pushups
//
//  Created by Venky Tumkur on 20/06/2022.
//

import Foundation

class WorkoutTimer: ObservableObject {
    private var workout: Workout
    
    @Published var totalSets = 2
    @Published var currentSet = 1
    @Published var secondsRemaining = 0
    @Published var pushupCount = 10
    @Published var isRestInterval = false
    
    var restCompleteAction: (() -> Void)?
    var restCompleteApproachingAction: (() -> Void)?
    var workoutCompleteAction: (() -> Void)?
    
    private var timer: Timer?
    private var frequency: TimeInterval { 1.0 / 60.0 }
    
    private var restCompleteApproachingActionTimeLimit = 5 // Time limit at which to start performing the rest complete approaching action
    private var lastActionTime = 0 // Time when the rest complete approaching action was last fired
    
    private var currentRestInterval: Int {
        if currentSet <= 1 {
            return 0
        }
        return workout.rest
    }
    
    init() {
        self.workout = Workout.sampleData
    }
    
    func reset(workout: Workout) {
        self.workout = workout
        self.totalSets = workout.sets.count
        self.currentSet = 0
        self.secondsRemaining = 0
        self.pushupCount = 10
        self.isRestInterval = false
    }
    
    func startWorkout() {
        nextSet()
    }
    
    func stopWorkout() {
        timer?.invalidate()
        timer = nil
    }
    
    func nextSet() {
        // If currently resting, fast-forward until next set
        if self.isRestInterval {
            self.secondsRemaining = 0
            self.isRestInterval = false
            return
        }
        
        let nextSet = currentSet + 1
        guard nextSet <= totalSets else {
            workoutCompleteAction?()
            return
        }
        currentSet = nextSet
        pushupCount = workout.sets[currentSet - 1] // Zero-index
        
        if currentRestInterval > 0 {
            isRestInterval = true
            secondsRemaining = workout.rest
            
            // Start countdown timer for rest interval
            let startTime = Date()
            timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true, block: { [weak self] timer in
                if let self = self {
                    let elapsed = Int(Date().timeIntervalSince1970 - startTime.timeIntervalSince1970)
                    self.secondsRemaining = self.currentRestInterval - elapsed
                    
                    if self.secondsRemaining <= 0 {
                        // Timer done
                        self.timer?.invalidate()
                        self.isRestInterval = false
                        self.restCompleteAction?()
                    } else if self.secondsRemaining <= self.restCompleteApproachingActionTimeLimit  && self.secondsRemaining != self.lastActionTime {
                        self.lastActionTime = self.secondsRemaining
                        self.restCompleteApproachingAction?()
                    }
                }
            })
        } else {
            // Wait for completion of workout set
            isRestInterval = false
        }
    }
    
}
    
