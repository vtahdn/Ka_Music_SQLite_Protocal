//
//  Artist.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/12/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import Foundation

class Artist: NSObject {
    
    var id = Int()
    var artistName = NSString()
    var born = NSString()
    var urlImg: String!
    
    init(id: Int, artistName: NSString, born: NSString, urlImg: NSString) {
        
        self.id = id
        self.artistName = artistName
        self.born = born
        self.urlImg = urlImg as String
        
    }
}
