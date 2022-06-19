//
//  CardView.swift
//  Pushups
//
//  Created by Venky Tumkur on 19/06/2022.
//

import SwiftUI

struct CardView: View {
    let workout: Workout
    
    var body: some View {
        VStack {
            Text("\(workout.repr)")
            Label("Day \(workout.day)", systemImage: "clock.fill")
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(workout: Workout.sampleData)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
