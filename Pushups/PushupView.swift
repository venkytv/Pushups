//
//  PushupView.swift
//  Pushups
//
//  Created by Venky Tumkur on 19/06/2022.
//

import SwiftUI

struct PushupView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var store: WorkoutStore
    
    let workout: Workout
    
    var body: some View {
        VStack {
            Text("Day \(workout.day)")
            Text("\(workout.repr)")
            Button(action: {
                store.currentWorkout = Workout(forDay: workout.day + 1)
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Text("Done")
            }
        }
    }
}

struct PushupView_Previews: PreviewProvider {
    static var previews: some View {
        PushupView(workout: Workout.sampleData)
    }
}
