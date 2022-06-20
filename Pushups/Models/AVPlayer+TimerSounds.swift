//
//  AVPlayer+TimerSounds.swift
//  Pushups
//
//  Created by Venky Tumkur on 20/06/2022.
//

import Foundation
import AVFoundation

extension AVPlayer {
    static let sharedDingPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "ding", withExtension: "wav") else {
            fatalError("Failed to find sound file for ding sound")
        }
        return AVPlayer(url: url)
    }()
    
    static let sharedTickPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "tick", withExtension: "wav") else {
            fatalError("Failed to find sound file for tick sound")
        }
        return AVPlayer(url: url)
    }()
}
