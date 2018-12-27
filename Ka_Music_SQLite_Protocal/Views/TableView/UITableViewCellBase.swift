//
//  UITableViewCellBase.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/11/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import UIKit
import AVFoundation

class UITableViewCellBase: UITableViewCell {
    
    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var btn_Play: UIButton!
    @IBOutlet weak var btn_addList: UIButton!
    @IBOutlet weak var layout_btnPlay: NSLayoutConstraint!
    
    var delegateSelect:SelectItem!
    let database = DataBase()
    var nameItem = ""
    var type = Type.NONE
    var object: NSObject!
    var checkAddItemsToCell = false
    
    var audioPlayer = AudioPlayer.sharedInstance
    
    let songInfo = { (_ controller: UITableViewCellBase) in
    
        if let song = controller.object as? Song {
            
            controller.name.text = String(song.songName!)
            controller.info.text = controller.nameItem
            controller.imgDetail.image = UIImage(named: song.urlImg as String)
            
        }
        
    }
    
    let artistInfo = { (_ controller: UITableViewCellBase) in
    
        controller.btn_Play.isHidden = true
        controller.btn_addList.isHidden = true
        if let artist = controller.object as? Artist {
            
            controller.name.text = String(artist.artistName)
            controller.info.text = String(artist.born)
            controller.imgDetail.image = UIImage(named: artist.urlImg as String)
            
        }
    }
    
    let playListInfo = { (_ controlller: UITableViewCellBase) in

        controlller.btn_addList.isHidden = true
//        controlller.layout_btnPlay.constant = 8
        if let playlist = controlller.object as? PlayList {
            controlller.name.text = String(describing: playlist.song.songName!)
            controlller.info.text = controlller.nameItem
            controlller.imgDetail.image = UIImage(named: playlist.song.urlImg as String)
        }
        
    }
    
    let changeInfo = { (_ controller: UITableViewCellBase) in
        
        switch controller.type {
        case .SONGS:
            controller.songInfo(controller)
            break
        case .ARTISTS:
            controller.artistInfo(controller)
            break
        case .PLAYLIST:
            controller.playListInfo(controller)
            break
        default:
            break
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // code common to all your cells goes here
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.black
        
    }
    
    @IBAction func playSong(_ sender: UIButton) {
        
        audioPlayer.songName = name.text!
        audioPlayer.play(audioPlayer)
        
    }

    @IBAction func addSong(_ sender: UIButton) {
        
        let originPoint = CGPoint(x: sender.frame.origin.x - 200, y: sender.frame.origin.y + sender.frame.height + 8)
        let point = self.convert(originPoint, to: self.superview!)
        self.delegateSelect.selectButtonAddPlayList!(id: Int(point.y)/86, point: point)
        
    }
    
    @IBAction func getInfo(sender: UIButton)
    {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.selectionStyle = .none
        
    }
    
}
