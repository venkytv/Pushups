//
//  PushupTimerView.swift
//  Pushups
//
//  Created by Venky Tumkur on 20/06/2022.
//

import SwiftUI

struct PushupTimerView: View {
    let isRestInterval: Bool
    let secondsRemaining: Int
    let pushupCount: Int
    let currentSet: Int
    let totalSets: Int
    
    var body: some View {
        Circle()
            .strokeBorder(lineWidth: 24)
            .overlay {
                if isRestInterval {
                    VStack {
                        Text("\(secondsRemaining)")
                            .font(.largeTitle)
                        Text("seconds")
                    }
                } else {
                    VStack {
                        Text("\(pushupCount)")
                            .font(.largeTitle)
                        Text("pushups")
                    }
                }
            }

    }
}

struct PushupTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PushupTimerView(isRestInterval: false, secondsRemaining: 5, pushupCount: 10, currentSet: 3, totalSets: 5)
    }
}
