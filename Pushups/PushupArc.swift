//
//  PushupArc.swift
//  Pushup Timer
//
//  Created by Venky Tumkur on 17/06/2022.
//

import SwiftUI

struct PushupArc: Shape {
    let currentSet: Int
    let totalSets: Int
    
    private var degreesPerSet: Double {
        360.0 / Double(totalSets)
    }
    
    private var startAngle: Angle {
        Angle(degrees: degreesPerSet * Double(currentSet - 1) + 1.0)
    }
    
    private var endAngle: Angle {
        Angle(degrees: startAngle.degrees + degreesPerSet - 1.0)
    }
    
    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        let radius = diameter / 2.0
        let centre = CGPoint(x: rect.midX, y: rect.midY)
        return Path { path in
            path.addArc(center: centre, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
    }
}
