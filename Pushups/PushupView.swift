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
    let theme: Theme
    
    private var dingPlayer: AVPlayer { AVPlayer.sharedDingPlayer }
    private var tickPlayer: AVPlayer { AVPlayer.sharedTickPlayer }
    
    private var synthesizer: AVSpeechSynthesizer { AVSpeechSynthesizer() }
    
    private func say(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.55
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        synthesizer.speak(utterance)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(theme.mainColor)
            VStack {
                PushupHeaderView(day: workout.day, currentSet: workoutTimer.currentSet, sets: workout.sets, theme: theme)
                PushupTimerView(isRestInterval: workoutTimer.isRestInterval, secondsRemaining: workoutTimer.secondsRemaining, pushupCount: workoutTimer.pushupCount, currentSet: workoutTimer.currentSet, totalSets: workoutTimer.totalSets, theme: theme)
                PushupFooterView(currentSet: workoutTimer.currentSet, totalSets: workoutTimer.totalSets, nextSetAction: workoutTimer.nextSet)
            }
            .padding()
            .foregroundColor(theme.accentColor)
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = true
                
                workoutTimer.reset(workout: workout)
                
                workoutTimer.workoutStartAction = { pushupCount in
                    say("Perform \(pushupCount) push-ups")
                }
                workoutTimer.restCompleteAction = { pushupCount in
                    say("Next set: \(pushupCount) push-ups")
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
                UIApplication.shared.isIdleTimerDisabled = false
            }
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PushupView_Previews: PreviewProvider {
    static var previews: some View {
        PushupView(workout: Workout.sampleData, theme: Theme.orange)
    }
}
