//
//  PushupFooterView.swift
//  Pushups
//
//  Created by Venky Tumkur on 20/06/2022.
//

import SwiftUI

struct PushupFooterView: View {
    let currentSet: Int
    let totalSets: Int
    let nextSetAction: ()->Void
    
    var body: some View {
        VStack {
            Button(action: nextSetAction) {
                Image(systemName: "forward.fill")
                    .font(.title)
            }
        }
        .padding([.bottom, .horizontal])
    }
}

struct PushupFooterView_Previews: PreviewProvider {
    static var previews: some View {
        PushupFooterView(currentSet: 3, totalSets: 5, nextSetAction: {})
    }
}
