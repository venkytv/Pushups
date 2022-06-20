//
//  WorkoutStore.swift
//  Pushups
//
//  Created by Venky Tumkur on 19/06/2022.
//

import Foundation

class WorkoutStore: ObservableObject {
    @Published var currentWorkout: Workout = Workout.sampleData
    
    public static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("workout.json")
    }
    
    static func load(completion: @escaping (Result<Workout, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(Workout(forDay: 1)))
                    }
                    return
                }
                
                let workout = try JSONDecoder().decode(Workout.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(workout))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(workout: Workout, completion: @escaping (Result<Void, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(workout)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
