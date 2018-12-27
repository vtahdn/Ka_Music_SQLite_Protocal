//
//  UITableViewControllerBase.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/20/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import Foundation
import UIKit

class UITableViewControllerBase: UIViewControllerBase {
    
    @IBOutlet weak var myTableView: UITableView!
    var indexSong = 0
    
    let artistWithSongID = { (_ controller: UIViewControllerBase) in
    
        for song in controller.items {
            
            let detail = controller.dataBase.view("DETAILALBUM", ["ARTISTS.ArtistName"], "JOIN ARTISTS On DETAILALBUM.ArtistID = ARTISTS.ID Where SongID = \(song["ID"]!)", controller.dataBase)
            controller.nameArtists.append(detail.first!["ArtistName"] as! String)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.backgroundColor = UIColor.black
        myTableView.separatorColor = UIColor.clear
        
    }
    
}
