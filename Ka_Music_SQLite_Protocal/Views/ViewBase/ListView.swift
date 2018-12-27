//
//  ListView.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/21/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import Foundation
import UIKit

class ListView: UITableView {
    
    var items = [Label]() {
        
        didSet {
            self.frame.size = CGSize(width: 200, height: items.count * 50)
            self.layer.borderColor = UIColor.white.cgColor
        }
        
    }
    
    var delegateSelectItem: SelectItem!
    var type = Type.NONE
    
    let selectOption = { (_ index: Int, _ controller: ListView) in

        switch controller.type {
        case .SONGS:
            controller.delegateSelectItem.selectSongsOption!(id: controller.items[index].id)
            break
        case .ALBUMS:
            controller.delegateSelectItem.selectAlbumsOption! (id: controller.items[index].id)
            break
        case .ARTISTS:
            controller.delegateSelectItem.selectArtistsOption!(id: controller.items[index].id)
            break
        case .GENRE :
            controller.delegateSelectItem.selectGenre!(id: controller.items[index].id)
        case .PLAYLIST:
            controller.delegateSelectItem.selectPlayList!(id: controller.items[index].id)
            break
        default:
            controller.deselectRow(at: controller.indexPathForSelectedRow!, animated: false)
            break
        }

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor(red: 24/255, green: 27/255, blue: 34/255, alpha: 1.0)
        self.layer.borderColor = UIColor(red: 251/255, green: 125/255, blue: 4/255, alpha: 1.0).cgColor
        self.delegate = self
        self.dataSource = self
        
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = UIColor(red: 24/255, green: 27/255, blue: 34/255, alpha: 1.0)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 251/255, green: 125/255, blue: 4/255, alpha: 1.0).cgColor
        self.delegate = self
        self.dataSource = self
        
    }

    
}

extension ListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectOption(indexPath.row, self)
        self.isHidden = true
    }
    
}

extension ListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{

        return items.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = self.dequeueReusableCell(withIdentifier: "Cell")
        let currentItem = items[indexPath.row]
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        cell?.selectionStyle = .default
        cell?.textLabel?.text = currentItem.displayName
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.textColor = UIColor.white
        cell?.backgroundColor = UIColor.black
        return cell!

    }
    
}
