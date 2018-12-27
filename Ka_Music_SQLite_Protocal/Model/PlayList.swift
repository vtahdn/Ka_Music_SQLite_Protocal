//
//  PlayList.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/12/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import Foundation

class PlayList: NSObject {
    
    var id = Int()
    var playListName = NSString()
    var song = Song()
    
    override init() {
        
        self.id = 0
        self.playListName = ""
        
    }
    
    init(id: Int, playListName: NSString, song: Song) {
        
        self.id = id
        self.playListName = playListName
        self.song = song
        
    }
    
}
