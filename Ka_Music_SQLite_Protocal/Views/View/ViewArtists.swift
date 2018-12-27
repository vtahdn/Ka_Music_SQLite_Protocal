//
//  ViewArtists.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/20/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import Foundation
import UIKit
class ViewArtists: UITableViewControllerBase {
    
    var songData = { ( _ statement: String, _ source: Any) in
        
        if let source = source as? ViewArtists {
            
            source.items.removeAll()
            source.items = source.dataBase.view("ARTISTS", ["*"], statement, source.dataBase)
            // super.myTableView.reloadData()
            source.myTableView.reloadData()
            
        }
        
    }
    
    var allArtistOrder = { () -> [Label] in
        
        return [Label(displayName: "Name", id: 1, column: "ArtistName")]
        
    }
    
    var currentObject = { (currentItem: NSDictionary) -> NSObject in
        
        return Artist(id: currentItem["ID"] as! Int, artistName: currentItem["ArtistName"] as! NSString,  born: currentItem["Born"] as! NSString, urlImg: currentItem["UrlImg"] as! NSString)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.myTableView.delegate = self
        super.myTableView.dataSource = self
        txt_Search.delegate = self
        songData("", self)
        
        // Override List View
        setupListView = { (_ source: Any) in
            
            if let source = source as? ViewArtists {
                
                source.labels = source.allArtistOrder()
                source.listView.delegateSelectItem = source
                source.listView.items = source.labels
                source.listView.type = Type.ARTISTS
                
            }
            
        }
        
        setupListView(self)
        loadTitle(currentIndexOption, self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupListView(self)
        
    }
    
}

extension ViewArtists: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension ViewArtists: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "UITableViewCellBase", bundle: nil) , forCellReuseIdentifier: "Cell")
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "Cell") as? UITableViewCellBase
        let currentItem = items[indexPath.row]
        cell!.object = currentObject(currentItem)
        cell!.type = Type.ARTISTS
        if nameArtists.count == items.count {
            cell?.nameItem = nameArtists[indexPath.row]
        }
        cell?.changeInfo(cell!)
        return cell!
        
    }
    
}

extension ViewArtists: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var statement = ""
        if string == "" {
            if textField.text!.count > 0 {
                statement = (textField.text! as NSString).substring(to: textField.text!.count - 1)
            } else {
                statement = ""
            }
        } else {
            statement = "\(textField.text!)\(string)"
        }
        self.songData("Where ArtistName Like '\(statement)%'", self)
        return true
        
    }
    
}

extension ViewArtists: SelectItem {
    
    func selectArtistsOption(id: Int) {
        
        currentIndexOption = id
        loadTitle(id, self)
        songData("Order by \(String(describing: labels[id - 1].column!)) ASC", self)
        
    }
    
}


