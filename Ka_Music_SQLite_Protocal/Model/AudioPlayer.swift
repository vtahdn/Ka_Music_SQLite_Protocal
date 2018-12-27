//
//  AudioPlayer.swift
//  SQLite_Music_Protocal_v2
//
//  Created by Viet Asc on 12/27/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AudioPlayer {
    
   static let sharedInstance = AudioPlayer()
    
    var audioPlayer = AVAudioPlayer()
    var songName = String()
    
    var play = { (_ source: Any) in
        
        if let source = source as? AudioPlayer {
            
            let sound = Bundle.main.path(forResource: source.songName, ofType: "mp3")
            do {
                source.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                source.audioPlayer.prepareToPlay()
                source.audioPlayer.play()
                print("Playing.")
            } catch {
                print(error)
            }
            
        }
        
    }
    
    
}
