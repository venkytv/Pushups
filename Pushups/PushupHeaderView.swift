//
//  PushupHeaderView.swift
//  Pushups
//
//  Created by Venky Tumkur on 20/06/2022.
//

import SwiftUI

struct PushupHeaderView: View {
    let day: Int
    let currentSet: Int
    let sets: [Int]
    let theme: Theme
        
    var completedSets: String {
        if currentSet < 2 { return "" }
        return sets.dropLast(sets.count - currentSet + 1).map {String($0)}.joined(separator: " - ") + " - "
    }
    
    var remainingSets: String {
        sets.dropFirst(max(currentSet - 1, 0)).map {String($0)}.joined(separator: " - ")
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Day \(day):")
                Text(completedSets).foregroundColor(theme.accentColor.opacity(0.4)) + Text(remainingSets).foregroundColor(theme.accentColor).fontWeight(.bold)
            }
        }
    }
}

struct PushupHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PushupHeaderView(day: 3, currentSet: 2, sets: [12, 13, 14, 15], theme: Theme.orange)
    }
}
