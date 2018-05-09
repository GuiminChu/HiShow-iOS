//
//  GMProfileSubTableViewController.swift
//
//  Created by Chu Guimin on 2018/5/8.
//  Copyright © 2018年 Chu Guimin. All rights reserved.
//

import UIKit

let kGMProfileSubTableViewControllerDidScrollNotification = "kGMProfileSubTableViewControllerDidScrollNotification"
let kGMProfileSubTableViewControllerUserInfo = "kGMProfileSubTableViewControllerUserInfo"

class GMProfileSubTableViewController: UITableViewController {
    
    weak var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == nil {
            self.scrollView = scrollView
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kGMProfileSubTableViewControllerDidScrollNotification), object: nil, userInfo: [kGMProfileSubTableViewControllerUserInfo : scrollView])
    }
    
//    func addNotification() {
//        NotificationCenter.default.addObserver(self, selector: #selector(superScrollViewDidScroll(_:)), name: NSNotification.Name(rawValue: kWBProfileViewControllerTableViewDidScrollNotification), object: nil)
//    }
//    
//    @objc func superScrollViewDidScroll(_ notification: NSNotification) {
//        self.scrollView?.contentOffset = CGPoint.zero
//    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
