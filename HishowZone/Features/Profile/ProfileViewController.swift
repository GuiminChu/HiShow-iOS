//
//  ProfileViewController.swift
//  HishowZone
//
//  Created by Chu Guimin on 16/9/9.
//  Copyright © 2016年 Chu Guimin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var uid: String? {
        didSet {
            reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 88.0
        
        
        tableView.register(ProfileAvatarCell)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        print(uid)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    enum Section: Int {
        case Avatar
        case Info
        case Desc
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = Section(rawValue: section) else {
            fatalError()
        }
        
        switch sec {
        case .Avatar:
            return 1
        case .Info:
            return 1
        case .Desc:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let sec = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        
        switch sec {
        case .Avatar:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(ProfileAvatarCell.reuseIdentifier, forIndexPath: indexPath) as! ProfileAvatarCell
            
            return cell
        case .Info:
            return UITableViewCell()
        case .Desc:
            return UITableViewCell()
        }
    }
}