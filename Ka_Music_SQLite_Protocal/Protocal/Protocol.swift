//
//  Protocol.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/16/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import Foundation
import CoreGraphics

enum Type {
    
    case SONGS
    case ALBUMS
    case ARTISTS
    case PLAYLIST
    case GENRE
    case CELL
    case NONE
    
}

@objc protocol SelectItem {
    
    @objc optional func selectPlayList(id: Int)
    @objc optional func selectSongsOption(id: Int)
    @objc optional func selectAlbumsOption(id: Int)
    @objc optional func selectArtistsOption(id: Int)
    @objc optional func selectGenre(id: Int)
    @objc optional func selectButtonAddPlayList(id: Int, point: CGPoint)
    
}
