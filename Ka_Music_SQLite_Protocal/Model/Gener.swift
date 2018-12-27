//
//  Gener.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/12/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import Foundation

class Gener: NSObject {
    
    var id = Int()
    var genreName = NSString()
    
    init(id: Int, genreName: NSString) {
        
        self.id = id
        self.genreName = genreName
        
    }
    
}
