//
//  CardView.swift
//  Pushups
//
//  Created by Venky Tumkur on 19/06/2022.
//

import SwiftUI

struct CardView: View {
    let workout: Workout
    let caption: String
    let image: String
    let theme: Theme
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(workout.repr)")
                .font(.headline)
            Spacer()
            HStack {
                Label(caption, systemImage: image)
                Spacer()
                Label("Day \(workout.day)", systemImage: "clock.fill")
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(theme.accentColor)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let theme: Theme = .orange
        CardView(workout: Workout.sampleData, caption: "Today's workout", image: "heart.fill", theme: theme)
            .background(theme.mainColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
