//
//  Song.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/12/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import Foundation

class Song: NSObject {
    
    var songName:NSString!
    var id:Int!
    var urlImg: NSString!
    
    override init() {
        songName = ""
        id = 0
    }
    
    init(id: Int, songName: NSString, urlImg: NSString) {
        self.id = id
        self.songName = songName
        self.urlImg = urlImg
    }
    
}
