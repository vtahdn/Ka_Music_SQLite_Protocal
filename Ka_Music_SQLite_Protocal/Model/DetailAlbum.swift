//
//  DetailAlbum.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/12/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import Foundation

class DetailAlbum: NSObject {
    
    var id = Int()
    var albumId = Int()
    var genreId = Int()
    var artistId = Int()
    
    init(id: Int, albumId: Int, genreId: Int, artistId: Int)
    {
        
        self.id = id
        self.albumId = albumId
        self.genreId = genreId
        self.artistId = artistId
        
    }
    
}
