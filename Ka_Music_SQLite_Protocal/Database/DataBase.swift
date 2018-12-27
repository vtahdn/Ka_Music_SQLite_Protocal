//
//  ViewController.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/8/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import UIKit

class DataBase {
    
    var databasePath = String()
    
    let path = { (_ controller: DataBase) in
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = NSString(string: dirPaths[0])
        controller.databasePath = docsDir.appendingPathComponent("contacts.db")
        
    }
    
    let create = { (_ controller: DataBase) -> Bool in
    
        let filemgr = FileManager.default
        if !filemgr.fileExists(atPath: controller.databasePath) {
            if let contactDB = FMDatabase(path: controller.databasePath) {
                if contactDB.open() {
                    let sql_Create_SONGS = "create table if not exists SONGS (ID integer primary key autoincrement, SongName text, UrlImg text)"
                    let sql_Create_DetailPlayList = "create table if not exists DetailPlayList (SongID integer, PlayListID integer, foreign key (SongID) references SONGS(ID), foreign key (PlayListID) references PLAYLIST(ID), primary key (SongID, PlayListID))"
                    let sql_Create_PlayList = "create table if not exists PLAYLIST (ID integer primary key autoincrement, PlaylistName text)"
                    let sql_Create_ALBUMS = "create table if not exists ALBUMS (ID integer primary key autoincrement, Price text, AlbumName text, ReleaseDate text, UrlImg text)"
                    let sql_Create_DetailAlbum = "create table if not exists DETAILALBUM (AlbumID integer, GenreID integer, ArtistID integer, SongID integer, foreign key (AlbumID) references ALBUMS(ID), foreign key (GenreID) references GENRES(ID), foreign key (ArtistID) references ARTISTS(ID), foreign key (SongID) references SONGS(ID), primary key (AlbumID, GenreID, ArtistID, SongID))"
                    let sql_Create_ARTISTS = "create table if not exists ARTISTS (ID integer primary key autoincrement, ArtistName text, UrlImg text, Born text not null)"
                    let sql_Create_GENRES = "create table if not exists GENRES (ID integer primary key autoincrement, GenreName text)"
                    if !contactDB.executeStatements(sql_Create_SONGS) {
                        print("Error: \(String(describing: contactDB.lastErrorMessage()))")
                    }
                    if !contactDB.executeStatements(sql_Create_DetailPlayList) {
                        print("Error: \(String(describing: contactDB.lastErrorMessage()))")
                    }
                    if !contactDB.executeStatements(sql_Create_PlayList) {
                        print("Error: \(String(describing: contactDB.lastErrorMessage()))")
                    }
                    if !contactDB.executeStatements(sql_Create_ALBUMS) {
                        print("Error: \(String(describing: contactDB.lastErrorMessage()))")
                    }
                    if !contactDB.executeStatements(sql_Create_DetailAlbum) {
                        print("Error: \(String(describing: contactDB.lastErrorMessage()))")
                    }
                    if !contactDB.executeStatements(sql_Create_ARTISTS) {
                        print("Error: \(String(describing: contactDB.lastErrorMessage()))")
                    }
                    if !contactDB.executeStatements(sql_Create_GENRES) {
                        print("Error: \(String(describing: contactDB.lastErrorMessage()))")
                    }
                    if !contactDB.executeStatements("PRAGMA foreign_keys = ON")
                    {
                        print("Error: \(String(describing: contactDB.lastErrorMessage()))")
                    }
                } else {
                    print("Error: \(String(describing: contactDB.lastErrorMessage()))")
                }
                contactDB.close()
                return true
            }
        } else {
        }
        return false
    }
    
    let insert = { ( _ nameTable: String, _ dict: NSDictionary, _ controller: DataBase) in
        //Insert
        var keys = String();
        var values = String();
        var first = true
        for key in dict.allKeys {
            if first {
                keys = "'" + (key as! String) + "'"
                values = "'" + (dict.object(forKey: key) as! String) + "'"
                first = false
                continue
            }
            keys = keys + "," + "'" + (key as! String) + "'"
            values = values + "," + "'" + (dict.object(forKey: key) as! String) + "'"
        }
        let contactDB = FMDatabase(path: controller.databasePath)
        if contactDB!.open() {
            if !contactDB!.executeStatements("PRAGMA foreign_keys = ON")
            {
                print("Error: \(String(describing: contactDB!.lastErrorMessage()))")
            }
            let insertSQL = "INSERT INTO \(nameTable) (\(keys)) VALUES (\(values))"
            let result = contactDB!.executeUpdate(insertSQL,
                                                  withArgumentsIn: nil)
            if !result {
                print("Error: \(String(describing: contactDB!.lastErrorMessage()))")
            }
        }
        contactDB!.close()
    }
    
    var delete = { (_ songId: Int, _ source: Any) in

        if let source = source as? DataBase {
            
            let contactDB = FMDatabase(path: source.databasePath)
            if contactDB!.open() {
                let detailAlbumQuery = "DELETE FROM DETAILALBUM WHERE SongID = (\(songId))"
                let detailAlbumResult = contactDB!.executeUpdate(detailAlbumQuery,
                                                           withArgumentsIn: nil)
                if detailAlbumResult {
                    print("DetailAlbum: Deleted.")
                }
                //
                let detailPlaylistQuery = "DELETE FROM DETAILPLAYLIST WHERE SongID = (\(songId))"
                let detailPlaylistResult = contactDB!.executeUpdate(detailPlaylistQuery,
                                                                 withArgumentsIn: nil)
                if detailPlaylistResult {
                    print("DetailPlaylist: Deleted.")
                }
                //
                let songsQuery = "DELETE FROM SONGS WHERE ID = (\(songId))"
                let songsResult = contactDB!.executeUpdate(songsQuery,
                                                           withArgumentsIn: nil)
                if songsResult {
                    print("Songs: Deleted.")
                }
                //
            }
            contactDB!.close()
        }
        
    }
    
    let newValue = { (_ controller: DataBase) in
        
        //ALBUMS
        controller.insert("ALBUMS", ["Price":"200.000", "AlbumName":"Muon yeu ai do ca cuoc doi", "ReleaseDate":"21/10/2018", "UrlImg":"2.jpg"], controller)
        controller.insert("ALBUMS", ["Price":"350.000", "AlbumName":"Dep nhat la em", "ReleaseDate":"10/09/2018", "UrlImg":"h2.jpg"], controller)
        controller.insert("ALBUMS", ["Price":"400.000", "AlbumName":"Thang dien", "ReleaseDate":"12/10/2018", "UrlImg":"b2.jpg"], controller)
        controller.insert("ALBUMS", ["Price":"700.000", "AlbumName":"Em da ngu chua", "ReleaseDate":"24/10/2018", "UrlImg":"bi2.jpg"], controller)
//        controller.insert("ALBUMS", ["Price":"150.000", "AlbumName":"Yêu Một Người Không Sai", "ReleaseDate":"19/5/2016", "UrlImg":"Yêu Một Người Không Sai.jpg"], controller)
        
        //ARTISTS
        controller.insert("ARTISTS", ["ArtistName":"Linh Ka", "Born":"10/09/2002", "UrlImg":"1.jpg"], controller)
        controller.insert("ARTISTS", ["ArtistName":"Long Hoang", "Born":"21/01/2003", "UrlImg":"h1.jpg"], controller)
        controller.insert("ARTISTS", ["ArtistName":"Chii Be", "Born":"30/08/2002", "UrlImg":"b1.jpg"], controller)
        controller.insert("ARTISTS", ["ArtistName":"Long Bii", "Born":"04/09/2002", "UrlImg":"bi2.jpg"], controller)
//        controller.insert("ARTISTS", ["ArtistName":"MAI FIN", "Born":"19/5/1993", "UrlImg":"Chủ Nhật Buồn .jpg"], controller)
        //Genres
        controller.insert("GENRES", ["GenreName":"Ka <3"], controller)
        controller.insert("GENRES", ["GenreName":"Linggka"], controller)
        
        //PlayList
        controller.insert("PLAYLIST", ["PlaylistName":"Nhac nghe luc quẩy"], controller)
        controller.insert("PLAYLIST", ["PlaylistName":"Nhạc nghe lúc bay"], controller)
        
        //Song
        //1
        controller.insert("SONGS", ["SongName":"Em gái mưa", "UrlImg":"3.jpg"], controller)
        //2
        controller.insert("SONGS", ["SongName":"Chưa bao giờ mẹ kể", "UrlImg":"4.jpg"], controller)
        //3
        controller.insert("SONGS", ["SongName":"Từ hôm nay", "UrlImg":"5.jpg"], controller)
        //4
        controller.insert("SONGS", ["SongName":"Đẹp nhất là em", "UrlImg":"6.jpg"], controller)
        //5
        controller.insert("SONGS", ["SongName":"Ánh nắng của anh", "UrlImg":"7.jpg"], controller)
        //6
        controller.insert("SONGS", ["SongName":"Nơi này có anh", "UrlImg":"8.jpg"], controller)
        //7
        controller.insert("SONGS", ["SongName":"Muốn yêu ai đó cả cuộc đời", "UrlImg":"9.jpg"], controller)
        //8
        controller.insert("SONGS", ["SongName":"Có em chờ", "UrlImg":"10.jpg"], controller)
        //9
        controller.insert("SONGS", ["SongName":"Hongkong1", "UrlImg":"11.jpg"], controller)
        //10
        controller.insert("SONGS", ["SongName":"Cho anh hỏi", "UrlImg":"12.jpg"], controller)
        
        //DetailPlaylist
        controller.insert("DETAILPLAYLIST", ["SongID":"1", "PlayListID":"1"], controller)
        controller.insert("DETAILPLAYLIST", ["SongID":"2", "PlayListID":"1"], controller)
        controller.insert("DETAILPLAYLIST", ["SongID":"3", "PlayListID":"1"], controller)
        controller.insert("DETAILPLAYLIST", ["SongID":"4", "PlayListID":"1"], controller)
        controller.insert("DETAILPLAYLIST", ["SongID":"5", "PlayListID":"1"], controller)
        controller.insert("DETAILPLAYLIST", ["SongID":"6", "PlayListID":"1"], controller)
        controller.insert("DETAILPLAYLIST", ["SongID":"7", "PlayListID":"1"], controller)
        controller.insert("DETAILPLAYLIST", ["SongID":"8", "PlayListID":"1"], controller)
        controller.insert("DETAILPLAYLIST", ["SongID":"9", "PlayListID":"1"], controller)
        controller.insert("DETAILPLAYLIST", ["SongID":"10", "PlayListID":"1"], controller)
        
        //DetailAlbum
        controller.insert("DETAILALBUM", ["AlbumID":"1", "GenreID":"1", "ArtistID":"1", "SongID":"1"], controller)
        controller.insert("DETAILALBUM", ["AlbumID":"1", "GenreID":"2", "ArtistID":"2", "SongID":"2"], controller)
        controller.insert("DETAILALBUM", ["AlbumID":"2", "GenreID":"1", "ArtistID":"3", "SongID":"3"], controller)
        controller.insert("DETAILALBUM", ["AlbumID":"2", "GenreID":"2", "ArtistID":"4", "SongID":"4"], controller)
        controller.insert("DETAILALBUM", ["AlbumID":"1", "GenreID":"1", "ArtistID":"1", "SongID":"5"], controller)
        controller.insert("DETAILALBUM", ["AlbumID":"1", "GenreID":"2", "ArtistID":"2", "SongID":"6"], controller)
        controller.insert("DETAILALBUM", ["AlbumID":"2", "GenreID":"1", "ArtistID":"3", "SongID":"7"], controller)
        controller.insert("DETAILALBUM", ["AlbumID":"2", "GenreID":"2", "ArtistID":"4", "SongID":"8"], controller)
        controller.insert("DETAILALBUM", ["AlbumID":"1", "GenreID":"1", "ArtistID":"1", "SongID":"9"], controller)
        controller.insert("DETAILALBUM", ["AlbumID":"1", "GenreID":"2", "ArtistID":"2", "SongID":"10"], controller)
        
    }
    
    let deleteDatabase = { (_ controller: DataBase) in
        do {
            let fileManager = FileManager.default
            let fileURL = NSURL(fileURLWithPath: controller.databasePath as String)
            try fileManager.removeItem(at: fileURL as URL)
            print("Database Deleted!")
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    let view = { (table: String, columns: [String], statement: String, controller: DataBase) -> [NSDictionary] in
        
        var allColumns = ""
        var items = [NSDictionary]()
        for column in columns {
            if (allColumns == "") {
                allColumns = column
            } else {
                allColumns = allColumns + "," + column
            }
        }
        let querySQL = "Select DISTINCT \(allColumns) From \(table) \(statement)"
        let contactDB = FMDatabase(path: controller.databasePath as String)
        if contactDB!.open() {
            let results:FMResultSet? = contactDB!.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            while ((results?.next()) == true)
            {
                items.append(results!.resultDictionary()! as NSDictionary)
            }
        }
        contactDB!.close()
        return items
    }
    
    init()
    {
        
        path(self)
//        deleteDatabase(self)
        if create(self) {
            newValue(self)
            print("A database is created.")
        } 
    }
    
}

