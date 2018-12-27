//
//  Album.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/12/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import Foundation

class Album: NSObject {
    
    var id = Int()
    var price = NSString()
    var albumName = NSString()
    var releaseDate = NSString()
    var urlImg: String!
    
    init(id: Int, price: NSString, albumName: NSString, releaseDate: NSString, urlImg: String) {
        
        self.id = id
        self.price = price
        self.albumName = albumName
        self.releaseDate = releaseDate
        self.urlImg = urlImg
        
    }
    
}
