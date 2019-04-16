//
//  MusicPlayer.swift
//  Mument
//
//  Created by Seongchan Kang on 16/04/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import Foundation
import AVKit
import MediaPlayer

class MusicPlayer {
    
    static var shared =  MPMusicPlayerController.applicationMusicPlayer
    
    private init() {
        
    }

    
}

class SyetemPlayer {
    
    
    static var shared = AVPlayer.init()
    
    private init() {
        
    }
    
    static func setItem(_ item:AVPlayerItem) {
        
        SyetemPlayer.shared = AVPlayer.init(playerItem: item)
//        AVPlayer.
    }
    
}
