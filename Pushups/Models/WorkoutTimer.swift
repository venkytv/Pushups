//
//  WorkoutTimer.swift
//  Pushups
//
//  Created by Venky Tumkur on 20/06/2022.
//

import Foundation

class WorkoutTimer: ObservableObject {
    private var workout: Workout
    
    private var workoutManager = WorkoutManager.shared
        
    @Published var totalSets = 2
    @Published var currentSet = 1
    @Published var secondsRemaining = 0
    @Published var pushupCount = 10
    @Published var isRestInterval = false
    
    var workoutStartAction: ((Int) -> Void)?
    var restCompleteAction: ((Int) -> Void)?
    var restCompleteApproachingAction: (() -> Void)?
    var workoutCompleteAction: (() -> Void)?
    
    private var timer: Timer?
    private var frequency: TimeInterval { 1.0 / 60.0 }
    
    private var totalPushups = 0
    
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
        workoutManager.startWorkout()
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
            
            self.timer?.invalidate()
            self.restCompleteAction?(self.pushupCount)
            
            workoutManager.startSet()
            
            return
        }
        
        let nextSet = currentSet + 1
        guard nextSet <= totalSets else {
            workoutManager.completeWorkout()
            workoutCompleteAction?()
            return
        }
        currentSet = nextSet
        pushupCount = workout.sets[currentSet - 1] // Zero-index
        totalPushups += pushupCount
        
        if currentSet == 1 {
            workoutStartAction?(pushupCount)
            workoutManager.startSet()
        }
        
        if currentRestInterval > 0 {
            // Record last set of pushups
            workoutManager.completeSet()
            
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
                        self.restCompleteAction?(self.pushupCount)
                        self.workoutManager.startSet()
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
    
