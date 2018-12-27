//
//  ViewSongs.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/20/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import Foundation
import UIKit

class ViewSongs: UITableViewControllerBase {
    
    var playlist = ListView(frame: CGRect(x: 0, y: 0, width: 200, height: 100), style: .plain)
    
    var songData = { (statement: String, source: Any) in
        
        if let source = source as? ViewSongs {
            source.items.removeAll()
            source.items = source.dataBase.view("SONGS", ["*"], statement, source.dataBase)
//            super.myTableView.reloadData()
            source.myTableView.reloadData()
        }
        
    }
    
    var playlistState = { (_ source: Any) in
        
        if let source = source as? ViewSongs {
            source.playlist.isHidden = !source.playlist.isHidden
        }
        
    }
    
    var info = { (_ source: Any) -> [Label] in
        
        var labels = [Label]()
        if let source = source as? ViewSongs {
            let dicts = source.dataBase.view("PlayList", ["*"], "", source.dataBase)
            for item in dicts {
                labels.append(Label(displayName: item["PlaylistName"] as? String, id: item["ID"] as? Int, column: "PlaylistName"))
            }
        }
        return labels
        
    }
    
    var add = { (_ source: Any) in
        
        if let source = source as? ViewSongs {
            source.playlist.backgroundColor = UIColor.black
            source.playlist.delegateSelectItem = source
            source.playlist.type = Type.PLAYLIST
            source.playlist.items = source.info(source)
            source.myTableView.addSubview(source.playlist)
            source.playlistState(source)
        }
        
    }
    
    var allSong = { () -> [Label] in
        
        return [Label(displayName: "Name", id: 1, column: "SongName"), Label(displayName: "ID", id: 2, column: "ID")]
        
    }
    
    var updateListView = { (_ source: Any) in
        
        if let source = source as? ViewSongs {
            source.setupListView = { (_ source: Any) in
                if let source = source as? ViewSongs {
                    source.labels = source.allSong()
                    source.listView.delegateSelectItem = source
                    source.listView.items = source.labels
                    source.listView.type = Type.SONGS
                }
            }
            source.setupListView(source)
        }
        
    }
    
    var currentObject = { (_ currentItem: NSDictionary) -> NSObject in
    
        return Song(id: currentItem["ID"] as! Int, songName: currentItem["SongName"] as! NSString, urlImg: currentItem["UrlImg"] as! NSString)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.myTableView.delegate = self
        super.myTableView.dataSource = self
        txt_Search.delegate = self
        songData("", self)
        artistWithSongID(self)
        add(self)
        updateListView(self)
        loadTitle(currentIndexOption, self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
}

extension ViewSongs: SelectItem {
    
    func selectSongsOption(id: Int) {
        
        currentIndexOption = id
        loadTitle(id, self)
        self.songData("Order by \(labels[id - 1].column!) ASC", self)
        
    }
    
    func selectButtonAddPlayList(id: Int, point: CGPoint) {
        
        playlist.frame.origin = point
        self.indexSong = id
        playlistState(self)
        myTableView.isScrollEnabled = !myTableView.isScrollEnabled
        
    }
    
    func selectPlayList(id: Int) {
        
        myTableView.isScrollEnabled = true
        self.playlist.deselectRow(at: playlist.indexPathForSelectedRow!, animated: true)
        self.indexSong = id
        let currentSong = items[self.indexSong]
        dataBase.insert("DETAILPLAYLIST", ["SongID":"\(currentSong["ID"]!)", "PlayListID":String(id)], dataBase)
        
    }
    
}

extension ViewSongs: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var statement = ""
        //Trường hợp string == "" nghĩa là đang xoá
        if string == "" {
            //Lớn hơn không mới cắt để tránh lỗi
            if textField.text!.count > 0 {
                statement = (textField.text! as NSString).substring(to: textField.text!.count - 1)
            } else {
                statement = ""
            }
        } else {
            statement = "\(textField.text!)\(string)"
        }
        self.songData("Where SongName Like '\(statement)%'", self)
        return true
    }
    
}

extension ViewSongs: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return items.count
    }
    
}

extension ViewSongs: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) in
            let currentItem = self.items[indexPath.row]
            self.dataBase.delete(currentItem["ID"] as! Int, self.dataBase)
            self.items.remove(at: indexPath.row)
            self.myTableView.reloadData()
        }
        edit.backgroundColor = .black
        return [edit]
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "UITableViewCellBase", bundle: nil) , forCellReuseIdentifier: "Cell")
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "Cell") as? UITableViewCellBase
        let currentItem = items[indexPath.row]
        cell!.object = currentObject(currentItem)
        cell!.type = Type.SONGS
        cell!.delegateSelect = self
        if nameArtists.count == items.count {
            cell?.nameItem = nameArtists[indexPath.row]
        }
        cell?.changeInfo(cell!)
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
        
    }
    
}
