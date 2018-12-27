//
//  AddView.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/12/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import UIKit

class AddView: UIViewController {
    
    @IBOutlet weak var lbl_Album: UILabel!
    @IBOutlet weak var lbl_ArtistName: UILabel!
    @IBOutlet weak var lbl_Genre: UILabel!
    @IBOutlet weak var txt_Name: UITextField!
    @IBOutlet weak var txt_ImgName: UITextField!
    
    let database = DataBase()
    var listView = ListView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), style: .plain)
    var labels = [Label]()
    
    private var albumID = 0
    private var artistID = 0
    private var genreID = 0
    private var activeList = false
    
    var state = { (_ source: Any) in
        
        if let source = source as? AddView {
            source.listView.isHidden = !source.listView.isHidden
        }
        
    }
    
    var position = { (_ sender: UILabel,_ source: Any) in
        
        if let source = source as? AddView {
            
            let frame = sender.frame
            source.state(source)
            source.listView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: 100)
            source.listView.reloadData()
            
        }
        
    }
    
    @objc func viewListItemsAlbum() {
        
        labels.removeAll()
        var allAlbums = [NSDictionary]()
        var statement = ""
        if artistID == 0 {
            allAlbums = database.view("ALBUMS", ["ID", "AlbumName"], statement, database)
        } else {
            statement =  "JOIN ALBUMS On DETAILALBUM.AlbumID = ALBUMS.ID Where DETAILALBUM.artistID = \(artistID)"
            allAlbums = database.view("DETAILALBUM", ["ALBUMS.AlbumName", "ALBUMS.ID"], statement, database)
        }
        for album in allAlbums {
            labels.append(Label(displayName: album["AlbumName"] as? String, id: album["ID"] as? Int, column: "AlbumName"))
        }
        listView.items = labels
        listView.type = Type.ALBUMS
        position(lbl_Album, self)
        
    }
    
    @objc func viewListItemsArtist() {
        
        labels.removeAll()
        var allArtists = [NSDictionary]()
        var statement = ""
        if albumID == 0 {
            allArtists = database.view("ARTISTS", ["ID", "ArtistName"], statement, database)
        } else {
            statement =  "JOIN ARTISTS On DETAILALBUM.ArtistID = ARTISTS.ID Where DETAILALBUM.albumID = \(albumID)"
            allArtists = database.view("DETAILALBUM", ["ARTISTS.ArtistName", "ARTISTS.ID"], statement, database)
        }
        for artist in allArtists {
            labels.append(Label(displayName: artist["ArtistName"] as? String, id: artist["ID"] as? Int, column: "ArtistName"))
        }
        listView.items = labels
        listView.type = Type.ARTISTS
        position(lbl_ArtistName, self)
        
    }
    
    @objc func viewListGenre()
    {
        labels.removeAll()
        let allGenres = database.view("GENRES", ["ID", "GenreName"], "", database)
        for genre in allGenres {
            labels.append(Label(displayName: genre["GenreName"] as? String, id: genre["ID"] as? Int, column: "GenreName"))
        }
        listView.items = labels
        listView.type = Type.GENRE
        position(lbl_Genre, self)
        
    }
    
    var gestureForLabels = { (_ source: AddView) in
        
        source.lbl_ArtistName.isUserInteractionEnabled = true
        source.lbl_Album.isUserInteractionEnabled = true
        source.lbl_Genre.isUserInteractionEnabled = true
        
        let tapAlbum = UITapGestureRecognizer(target: source, action: #selector(viewListItemsAlbum))
        source.lbl_Album.addGestureRecognizer(tapAlbum)
        
        let tapArtist = UITapGestureRecognizer(target: source, action: #selector(viewListItemsArtist))
        source.lbl_ArtistName.addGestureRecognizer(tapArtist)
        
        let tapGenre = UITapGestureRecognizer(target: source, action: #selector(viewListGenre))
        source.lbl_Genre.addGestureRecognizer(tapGenre)
        
    }
    
    var add = { (_ source: Any) in
        
        if let source = source as? AddView {
            source.listView.delegateSelectItem = source
            source.state(source)
            source.view.addSubview(source.listView)
        }
        
    }
    
    var insert = { (_ source: Any) in

        if let source = source as? AddView {
            source.database.insert("SONGS", ["SongName":"\(source.txt_Name.text!)", "UrlImg":"\(source.txt_ImgName.text!).jpg"], source.database)
            let songID = source.database.view("SONGS", ["Count(ID)"], "", source.database).first!["Count(ID)"] as! Int
            source.database.insert("DETAILALBUM", ["AlbumID":"\(source.albumID)", "GenreID":"\(source.genreID)", "ArtistID":"\(source.artistID)", "SongID":"\(songID)"], source.database)
        }
        
    }
    
    var artirstID = { (_ name: String, _ source: Any) in
        
        if let source = source as? AddView {
            print(source.database.view("ARTISTS", ["*"], "Where ARTISTS.ArtistName='\(name)'", source.database))
            print("")
        }
        
    }
    
    var titleID = { (_ index: Int, _ source: Any) -> String? in
    
        if let source = source as? AddView {
            for label in source.labels {
                if label.id == index {
                    return label.displayName
                }
            }
        }
        return nil
        
    }
    
    var titleForLabel = { (sender: UILabel, title: String) in
        
        sender.text = title
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gestureForLabels(self)
        add(self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for gesture in self.view.gestureRecognizers!
        {
            if (gesture.isKind(of: UIGestureRecognizer.self))
            {
                self.view.removeGestureRecognizer(gesture)
            }
        }
    }
    
    @IBAction func action_Create(sender: AnyObject) {
        if (checkRequirement())
        {
            insert(self)
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            print("Please Enter All The Required")
        }
        
    }
    
    func checkRequirement() -> Bool
    {
        if (albumID == 0 || artistID == 0 || genreID == 0 || txt_Name.text == "" || txt_ImgName.text == "")
        {
            return false
        }
        return true
    }
    
    @IBAction func action_Cancel(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        state(self)
        
    }
    
}

extension AddView: SelectItem {
    
    func selectGenre(id: Int) {
        
        self.genreID = id
        titleForLabel(lbl_Genre, titleID(id, self)!)
        
    }
    
    func selectAlbumsOption(id: Int) {
        
        self.albumID = id
        titleForLabel(lbl_Album, titleID(id, self)!)
        
    }
    
    func selectArtistsOption(id: Int) {
        
        self.artistID = id
        titleForLabel(lbl_ArtistName, titleID(id, self)!)
        
    }
    
}
