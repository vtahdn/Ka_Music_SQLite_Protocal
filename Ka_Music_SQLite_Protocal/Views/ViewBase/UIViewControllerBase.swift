//
//  UIViewControllerBase.swift
//  SQLiteSample
//
//  Created by Tuuu on 7/20/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import UIKit

class UIViewControllerBase: UIViewController{
    
    @IBOutlet weak var txt_Search: UITextField!
    @IBOutlet weak var btn_Title: UIButton!
    
    var labels = [Label]()
    var listView = ListView(frame: CGRect(x: 0, y: 0, width: 200, height: 100), style: .plain)
    let dataBase = DataBase()
    var items = [NSDictionary]()
    var type = Type.SONGS
    var nameArtists = [String]()
    var currentIndexOption = 1
    
    let hide = { (_ controller: UIViewControllerBase) in
        controller.listView.isHidden = true
        controller.txt_Search.isHidden = true
    }
    
    let options = { (_ controller: UIViewControllerBase) in
        
        controller.listView = ListView(frame: CGRect(x: controller.btn_Title.center.x - 100, y: controller.btn_Title.frame.origin.y + controller.btn_Title.frame.size.height, width: 200, height: 100), style: .plain)
        controller.view.addSubview(controller.listView)
        
    }
    
    let state = { (isSearched: Bool, _ controller: UIViewControllerBase) in
        
        if isSearched {
            
            controller.btn_Title.isEnabled = !controller.txt_Search.isHidden
            
        } else {
            
            controller.tabBarController!.navigationItem.rightBarButtonItem!.isEnabled = !controller.tabBarController!.navigationItem.rightBarButtonItem!.isEnabled
            
        }
    }
    
    @objc func isHidden() {
        
        state(true, self)
        if txt_Search.isHidden == true {
            UIView.transition(with: self.txt_Search, duration: 0.5, options: UIView.AnimationOptions.transitionCurlDown, animations: nil, completion: nil)
            self.txt_Search.becomeFirstResponder() //Show keyboard
            self.txt_Search.isHidden = false
        } else {
            UIView.transition(with: self.txt_Search, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: nil, completion: nil)
            self.txt_Search.resignFirstResponder() // End edit text
            self.txt_Search.isHidden = true
        }
        
    }
    
    let rightBarButton = { (_ controller: UIViewControllerBase) in
        
        controller.tabBarController!.navigationItem.rightBarButtonItem?.target = controller
        controller.tabBarController!.navigationItem.rightBarButtonItem?.action = #selector(isHidden)
        
    }
    
    let selectFirstItem = { (_ controller: UIViewControllerBase) in
        
        let indexPath = NSIndexPath(row: controller.currentIndexOption-1, section: 0)
        controller.listView.selectRow(at: indexPath as IndexPath, animated: false, scrollPosition: .none)
        
    }
    
    let titleWithID = { (index: Int, _ controller: UIViewControllerBase) -> String? in
        
        for label in controller.labels
        {
            if (label.id == index)
            {
                return label.displayName
            }
        }
        return nil
        
    }
    
    let loadTitle = { (_ index: Int, _ controller: UIViewControllerBase) in
        
        controller.btn_Title.setTitle(controller.titleWithID(index, controller), for: .normal)
        controller.tabBarController!.navigationItem.rightBarButtonItem!.isEnabled = true
        
    }
    
    var setupListView = { (_ object: Any) in
        
        let controller = object as! UIViewControllerBase
        controller.listView.items = controller.labels
        controller.listView.type = Type.PLAYLIST
        controller.loadTitle(controller.currentIndexOption, controller)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .all
        hide(self)
        txt_Search.placeholder = "Enter name here"
        self.btn_Title.backgroundColor = UIColor(red: 39/255, green: 42/277, blue: 49/277, alpha: 1.0)
        self.view.backgroundColor = UIColor(red: 24/255, green: 27/277, blue: 34/277, alpha: 1.0)
        let textAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 26)!]
        btn_Title.titleLabel?.font = UIFont(name: "Helvetica", size: 22)
        self.tabBarController!.navigationItem.title = "Ka <3"
        self.navigationController?.navigationBar.titleTextAttributes = textAttribute
        self.view.backgroundColor = UIColor(red: 24/255, green: 27/255, blue: 34/255, alpha: 1.0)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if listView.frame.origin.x == 0 {
            
            options(self)
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hide(self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rightBarButton(self)
        selectFirstItem(self)
        setupListView(self)
        hide(self)
        
    }
    
    @IBAction func action_Label(sender: UIButton) {
        listView.isHidden = !listView.isHidden
        state(false, self)
    }
    
}
