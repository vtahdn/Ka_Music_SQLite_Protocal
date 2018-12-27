//
//  ViewPlaylists.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/20/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import Foundation
import UIKit

class ViewPlayLists: UITableViewControllerBase {
    
    var currentID = 1
    
    var songData = { (_ id: String, _ statement: String, _ source: Any) in
        
        if let source = source as? ViewPlayLists {
            
            source.items.removeAll()
            source.items = source.dataBase.view("PLAYLIST", ["*"], "JOIN DetailPlayList On PLAYLIST.Id = DetailPlayList.PlayListId JOIN SONGS On SONGS.Id = DetailPlayList.SONGID where PLAYLIST.Id = \(id) \(statement)", source.dataBase)
            source.myTableView.reloadData()
        }
        
    }
    
    var info = { (_ source: Any) -> [Label] in
        
        var labels = [Label]()
        if let source = source as? ViewPlayLists {
            let dicts = source.dataBase.view("PlayList", ["*"], "", source.dataBase)
            for item in dicts {
                labels.append(Label(displayName: item["PlaylistName"] as? String, id: item["ID"] as? Int, column: "PlaylistName"))
            }
        }
        return labels
        
    }
    
    var updateListView = { (_ source: Any) in
        
        if let source = source as? ViewPlayLists {
            source.setupListView = { (_ source: Any) in
                if let source = source as? ViewPlayLists {
                    
                    source.labels = source.info(self)
                    source.listView.delegateSelectItem = source
                    source.listView.items = source.labels
                    source.listView.type = Type.PLAYLIST
                    
                }
            }
            source.setupListView(source)
        }
        
    }
    
    var currentObject = { (currentItem: NSDictionary) -> NSObject in
        return PlayList(id: currentItem["ID"] as! Int, playListName: currentItem["PlaylistName"] as! NSString, song: Song(id: currentItem["SongID"] as! Int, songName: currentItem["SongName"] as! NSString, urlImg: currentItem["UrlImg"] as! String as NSString))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.myTableView.delegate = self
        super.myTableView.dataSource = self
        txt_Search.delegate = self
        songData("1", "", self)
        artistWithSongID(self)
        updateListView(self)
        loadTitle(currentIndexOption, self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateListView(self)
    }

}

extension ViewPlayLists: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
        
    }
    
}

extension ViewPlayLists: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "UITableViewCellBase", bundle: nil) , forCellReuseIdentifier: "Cell")
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "Cell") as? UITableViewCellBase
        let currentItem = items[indexPath.row]
        cell!.object = currentObject(currentItem)
        cell!.type = Type.PLAYLIST
        //        cell!.delegateSelect = self
        if nameArtists.count == items.count
        {
            cell?.nameItem = nameArtists[indexPath.row]
        }
        cell?.changeInfo(cell!)
        return cell!
        
    }
    
}

extension ViewPlayLists: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var name = ""
        if string == "" {
            if textField.text!.count > 0 {
                name = (textField.text! as NSString).substring(to: textField.text!.count - 1)
            } else {
                name = ""
            }
        } else {
            name = "\(textField.text!)\(string)"
        }
        self.songData(String(currentID), "And SONGS.SongName Like '\(name)%'", self)
        return true
    }
    
}

extension ViewPlayLists: SelectItem {
    
    func selectPlayList(id: Int) {
        
        currentIndexOption = id
        loadTitle(id, self)
        songData(String(id), "", self)
        artistWithSongID(self)
        
    }
    
}
