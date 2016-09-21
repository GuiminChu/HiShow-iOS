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
    
    var userInfo: UserInfo? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        
        // tableViewCell 自动计算高度
        tableView.estimatedRowHeight = 88.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(ProfileAvatarCell.self)
        tableView.register(UserInfoCell.self)
        tableView.register(DescCell.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        HiShowAPI.sharedInstance.getUserInfo(uid: uid!,
            completion: { userInfo in
                //
                self.userInfo = userInfo
            },
            failureHandler: { (reason, errorMessage) in
                //
            }
        )
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
        case avatar
        case info
        case desc
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = Section(rawValue: section) else {
            fatalError()
        }
        
        switch sec {
        case .avatar:
            return 1
        case .info:
            return 1
        case .desc:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sec = Section(rawValue: (indexPath as NSIndexPath).section) else {
            fatalError()
        }
        
        switch sec {
        case .avatar:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileAvatarCell.reuseIdentifier, for: indexPath) as! ProfileAvatarCell
            cell.configure(self.userInfo?.largeAvatar)
            
            return cell
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoCell.reuseIdentifier, for: indexPath) as! UserInfoCell
            cell.configure(self.userInfo)
            
            return cell
        case .desc:
            let cell = tableView.dequeueReusableCell(withIdentifier: DescCell.reuseIdentifier, for: indexPath) as! DescCell
            cell.configure(self.userInfo?.desc)
            
            return cell
        }
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        guard let sec = Section(rawValue: indexPath.section) else {
//            fatalError()
//        }
//        
//        switch sec {
//        case .Avatar:
//            
//            return 176.0
//        case .Info:
//            return 44.0
//        case .Desc:
//            return 44.0
//        }
//    }
}
