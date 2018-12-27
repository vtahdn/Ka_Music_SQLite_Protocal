//
//  ViewAlbums.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/20/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import Foundation
import UIKit

class ViewAlbums: UICollectionViewBase {
    
    var data = { (_ statement: String, _ source: Any) in
    
        if let source = source as? ViewAlbums {
            source.items.removeAll()
            source.items = source.dataBase.view("ALBUMS", ["*"], statement, source.dataBase)
            source.myCollectionView.reloadData()
        }
        
    }
    
    var updateListView = { (_ source: Any) in
        
        if let source = source as? ViewAlbums {
            source.setupListView = { (_ source: Any) in
                if let source = source as? ViewAlbums {
                    
                    source.labels = source.allAlbumOrder(source)
                    source.listView.delegateSelectItem = source
                    source.listView.type = Type.ALBUMS
                    source.listView.items = source.labels
                    
                }
            }
            source.setupListView(source)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myCollectionView.backgroundColor = UIColor(red: 24/255, green: 27/277, blue: 34/277, alpha: 1.0)
        self.myCollectionView.register(UINib(nibName: "CollectionViewCellALBUM", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        updateListView(self)
        data("", self)
        loadTitle(currentIndexOption, self)
        
    }

}

extension ViewAlbums: UICollectionViewDelegate {
    
}

extension ViewAlbums: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCellALBUM
        let album = Album(id: items[indexPath.row]["ID"] as! Int, price: items[indexPath.row]["Price"] as! NSString, albumName: items[indexPath.row]["AlbumName"] as! NSString, releaseDate: items[indexPath.row]["ReleaseDate"] as! NSString, urlImg: items[indexPath.row]["UrlImg"] as! String)
        cell.lbl_AlbumName.text = album.albumName  as String
        cell.lbl_ArtistName.text = album.releaseDate as String
        cell.img_Detail.image = UIImage(named: album.urlImg as String)
        return cell
    }
    
}

extension ViewAlbums: SelectItem {
    
    func selectAlbumsOption(id: Int) {
        currentIndexOption = id
        loadTitle(id, self)
        self.data("Order by \(String(describing: labels[id - 1].column!)) ASC", self)
    }
    
}

