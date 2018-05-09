//
//  ProfileViewController.swift
//  HiShow
//
//  Created by Chu Guimin on 16/9/9.
//  Copyright © 2016年 Chu Guimin. All rights reserved.
//

let headViewH =  kScreenWidth / 5 * 2
let headH = kScreenWidth / 5

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bgImageView: UIImageView?
    var blurView: UIVisualEffectView?
    var headerImageView: UIImageView?
    var scale: CGFloat?
    
    var author: Author!
    
    var uid: String? {
        didSet {
            requestData()
        }
    }
    
    var userInfo: UserInfo? {
        didSet {
            tableView.reloadData()
        }
    }

//    lazy var navBar = WRCustomNavigationBar.CustomNavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navBarBackgroundAlpha = 0
        
//        navigationController?.navigationBar.isHidden = true
//        automaticallyAdjustsScrollViewInsets = false
//        navBar.wr_setBackgroundAlpha(alpha: 0)
//        navBar.wr_setLeftButton(title: "<<", titleColor: UIColor.white)
//        view.addSubview(navBar)
        
        // 设置导航栏颜色
        navBarBarTintColor = UIColor.init(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
        
        // 设置初始导航栏透明度
        navBarBackgroundAlpha = 0
        
        // 设置导航栏按钮和标题颜色
        navBarTintColor = .white
        
        navBarShadowImageHidden = true

        setupTableView()
        setupHeaderView()
        
        uid = author.id
    }
    
    func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: headViewH, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.tableFooterView = UIView()
        
        // tableViewCell 自动计算高度
        tableView.estimatedRowHeight = 88.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(ProfileAvatarCell.self)
        tableView.register(UserInfoCell.self)
        tableView.register(DescCell.self)
    }
    
    func setupHeaderView() {
        
        bgImageView = UIImageView(frame: CGRect(x: 0, y: -headViewH, width: kScreenWidth, height: headViewH))
//        bgImageView!.image = UIImage(named: "Image")
        bgImageView!.kf.setImage(with: URL(string: author.largeAvatar!), options: [KingfisherOptionsInfoItem.transition(ImageTransition.fade(0.25))])
        
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView?.frame = bgImageView!.frame
        
        headerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: headH, height: headH))
        headerImageView?.center = bgImageView!.center
//        headerImageView?.image =  UIImage(named: "Image")
        headerImageView!.kf.setImage(with: URL(string: author.largeAvatar!), options: [KingfisherOptionsInfoItem.transition(ImageTransition.fade(0.25))])
        headerImageView?.layer.cornerRadius = headH / 2
        headerImageView?.layer.masksToBounds = true
        
        tableView.addSubview(bgImageView!)
        tableView.addSubview(blurView!)
        tableView.addSubview(headerImageView!)
        
        scale = bgImageView!.bounds.size.width / bgImageView!.bounds.size.height

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestData() {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        print(offsetY)
        if offsetY < -headViewH {
            
            bgImageView?.frame = CGRect(x: 0, y: offsetY, width: kScreenWidth, height: -offsetY)
            blurView?.frame = bgImageView!.frame
            let conY = scrollView.contentOffset.y + headViewH
            print("conY:\(conY)")
            print("scale:\(scale)")
            
            let imgH = -offsetY
            let imgW = imgH * scale!
            bgImageView?.frame = CGRect(x: -(imgW - kScreenWidth)/2, y: offsetY, width: imgW, height: imgH)
            blurView?.frame = bgImageView!.frame
            
            headerImageView?.frame = CGRect(x: 0, y: 0, width: headH-conY, height: headH-conY)
            headerImageView?.center = bgImageView!.center
            headerImageView?.layer.cornerRadius = headerImageView!.bounds.size.height / 2
        }
    }
}
