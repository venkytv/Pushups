//
//  PushupView.swift
//  Pushups
//
//  Created by Venky Tumkur on 19/06/2022.
//

import SwiftUI
import AVFoundation

struct PushupView: View {
    @StateObject var workoutTimer = WorkoutTimer()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var store: WorkoutStore
    
    let workout: Workout
    
    private var dingPlayer: AVPlayer { AVPlayer.sharedDingPlayer }
    private var tickPlayer: AVPlayer { AVPlayer.sharedTickPlayer }
    
    var body: some View {
        VStack {
            PushupHeaderView(day: workout.day, currentSet: workoutTimer.currentSet, sets: workout.sets)
            PushupTimerView(isRestInterval: workoutTimer.isRestInterval, secondsRemaining: workoutTimer.secondsRemaining, pushupCount: workoutTimer.pushupCount, currentSet: workoutTimer.currentSet, totalSets: workoutTimer.totalSets)
            PushupFooterView(currentSet: workoutTimer.currentSet, totalSets: workoutTimer.totalSets, nextSetAction: workoutTimer.nextSet)
        }
        .padding()
        .onAppear {
            workoutTimer.reset(workout: workout)
            
            workoutTimer.restCompleteAction = {
                dingPlayer.seek(to: .zero)
                dingPlayer.play()
            }
            workoutTimer.restCompleteApproachingAction = {
                tickPlayer.seek(to: .zero)
                tickPlayer.play()
            }
            workoutTimer.workoutCompleteAction = {
                store.currentWorkout = Workout(forDay: workout.day + 1)
                self.presentationMode.wrappedValue.dismiss()
            }
            
            workoutTimer.startWorkout()
        }
        .onDisappear {
            workoutTimer.stopWorkout()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PushupView_Previews: PreviewProvider {
    static var previews: some View {
        PushupView(workout: Workout.sampleData)
    }
}
