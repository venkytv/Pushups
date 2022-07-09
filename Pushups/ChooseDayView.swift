//
//  ChooseDayView.swift
//  Pushups
//
//  Created by Venky Tumkur on 09/07/2022.
//

import SwiftUI
import Combine

struct ChooseDayView: View {
    @EnvironmentObject var store: WorkoutStore
    
    @State var day: String = "1"
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Schedule Day", text: $day)
                    .keyboardType(.numberPad)
                    .onReceive(Just(day)) { newDay in
                        let filtered = newDay.filter { "0123456789".contains($0)
                        }
                        if filtered != newDay {
                            self.day = filtered
                        }
                    }
            }
            .navigationBarTitle("Choose Day")
            .onAppear {
                day = String(store.currentWorkout.day)
            }
            .onDisappear {
                store.currentWorkout = Workout(forDay: Int(day) ?? 1)
            }
        }
    }
}

struct ChooseDayView_Previews: PreviewProvider {
    static var previews: some View {
        let store: WorkoutStore = WorkoutStore()
        NavigationView {
            ChooseDayView()
        }
        .environmentObject(store)
    }
}
