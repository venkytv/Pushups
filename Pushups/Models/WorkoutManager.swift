//
//  WorkoutManager.swift
//  Pushups
//
//  Created by Venky Tumkur on 23/06/2022.
//

import Foundation
import HealthKit

class WorkoutManager: ObservableObject {
    static let shared = WorkoutManager()
    
    let healthStore = HKHealthStore()
    
    var workoutStart: Date?
    var workoutEnd: Date?
    var pushupTime: TimeInterval = 0
    
    private var setStartTime: Date?
    
    func requestAuthorization() {
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .bodyMass)!,
        ]
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            if !success {
                fatalError("Authorization request error: \(String(describing: error))")
            }
        }
        
    }
    
    func startWorkout() {
        workoutStart = Date()
        workoutEnd = nil
        pushupTime = 0
    }
    
    func startSet() {
        setStartTime = Date()
    }
    
    func completeSet() {
        if let start = setStartTime {
            let interval = Date().timeIntervalSince(start)
            pushupTime += interval
            setStartTime = nil
        }
    }
    
    private func getMostRecentSample(sampletype: HKSampleType, completion: @escaping (HKQuantitySample) -> Void) {
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date())
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let sampleQuery = HKSampleQuery(sampleType: sampletype, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { query, samples, error in
            DispatchQueue.main.async {
                guard let samples = samples, let mostRecentSample = samples.first as? HKQuantitySample else {
                    print("No sample found for \(sampletype)")
                    return
                }
                completion(mostRecentSample)
            }
        }
        healthStore.execute(sampleQuery)
    }
    
    func getUserWeight() -> Double {
        var weight = 70.0 // Average
        
        guard let bodyMass = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Weight not available in HealthKit")
            return weight
        }
        
        getMostRecentSample(sampletype: bodyMass) { sample in
            weight = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
        }
        return weight
    }
    
    func getBasalEnergyBurned() -> Double {
        var met = 3.5 // Average
        
        guard let basalEnergyBurned = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned) else {
            print("Basal energy burned not available in HealthKit")
            return met
        }
        
        getMostRecentSample(sampletype: basalEnergyBurned) { sample in
            met = sample.quantity.doubleValue(for: HKUnit.kilocalorie())
        }
        return met
    }
    
    func completeWorkout() {
        completeSet()
        workoutEnd = Date()
        
        guard let start = workoutStart, let end = workoutEnd else {
            print("Workout start or end time not set!")
            return
        }
        
        // Load most recent weight
        let weight = getUserWeight()
        
        let stdMET = 3.8 // for moderate pushups
        
        let kcalPerMinute = stdMET * 3.5 * weight / 200.0
        let energyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: kcalPerMinute * Double(pushupTime) / 60.0)
        let workout = HKWorkout(activityType: HKWorkoutActivityType.functionalStrengthTraining, start: start, end: end, duration: pushupTime, totalEnergyBurned: energyBurned, totalDistance: nil, metadata: nil)
        
        healthStore.save(workout) { (success, error) in
            guard success else {
                print("Error saving workout: \(String(describing: error))")
                return
            }
        }
    }
}
