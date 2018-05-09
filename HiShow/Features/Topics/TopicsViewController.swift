//
//  TopicsViewController.swift
//  HishowZone
//
//  Created by Chu Guimin on 16/9/6.
//  Copyright © 2016年 Chu Guimin. All rights reserved.
//

import UIKit
import ESPullToRefresh

class TopicsViewController: UIViewController, SegueHandlerType {

    enum SegueIdentifier: String {
        case ToProfileSegue
        case ToTopicDetailSegue
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var navBar = WRCustomNavigationBar.CustomNavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.isHidden = true
//        automaticallyAdjustsScrollViewInsets = false
        
//        setupNavBar()
//
//        if #available(iOS 11.0, *) {
//            tableView.contentInsetAdjustmentBehavior = .never
//        }
//
//        view.insertSubview(navBar, aboveSubview: tableView)
//        navBar.title = "自定义导航栏"
        // 定义子界面返回键的文字文本
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)

        tableView.register(TopicItemCell.self)
        
        initPullToRefresh()
        TopicItemStore.shared.start = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(topicsDidChange), name: NSNotification.Name(rawValue: activityInfoStoreDidChangedNotification), object: nil)
    }
    
    fileprivate func setupNavBar() {
        
        view.addSubview(navBar)
        
        // 设置自定义导航栏背景图片
//        navBar.barBackgroundImage = UIImage(named: "millcolorGrad")
        
        // 设置自定义导航栏背景颜色
//         navBar.backgroundColor = .black
        navBar.barBackgroundColor = .black
        
        // 设置自定义导航栏标题颜色
        navBar.titleLabelColor = .white
        
        // 设置自定义导航栏左右按钮字体颜色
        navBar.wr_setTintColor(color: .white)
        
        if self.navigationController?.childViewControllers.count != 1 {
            navBar.wr_setLeftButton(title: "<<", titleColor: UIColor.white)
        }
    }
    
    func initPullToRefresh() {
        self.tableView.es.addPullToRefresh { [unowned self] in
            TopicItemStore.shared.start = 0
        }
        
        self.tableView.es.addInfiniteScrolling { [unowned self] in
            TopicItemStore.shared.start += 20
        }
    }
    
    @objc func topicsDidChange(_ notification: Notification) {
        let xx = notification.userInfo![notification.name.rawValue] as! RefreshStatus
        switch xx {
        case .none:
            print("none")
        case .pullSucess(let hasMoreData):
            self.tableView.reloadData()
            self.tableView.es.stopPullToRefresh()
            if hasMoreData {
                self.tableView.es.resetNoMoreData()
            } else {
                self.tableView.es.noticeNoMoreData()
            }
        case .loadSucess(let hasMoreData):
            self.tableView.reloadData()
            self.tableView.es.stopLoadingMore()
            if !hasMoreData {
                self.tableView.es.noticeNoMoreData()
            }
        case .error(let message):
            self.tableView.es.stopPullToRefresh()
            self.tableView.es.stopLoadingMore()
//            self.tableView.mj_footer.endRefreshing()
            print(message)
        }
        
    }
}

// MARK: - Navigation

extension TopicsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifierForSegue(segue) {
        case .ToProfileSegue:
            
            let controller = segue.destination as! ProfileViewController
//            controller.uid = sender as? String
            controller.author = sender as! Author
        case .ToTopicDetailSegue:

            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! TopicDetailViewController
                controller.topic = TopicItemStore.shared.topic(at: indexPath.row)
            }
        }
    }
}

// MARK: - Table view data source

extension TopicsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TopicItemStore.shared.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TopicItemCell.reuseIdentifier, for: indexPath) as! TopicItemCell

        cell.configure(TopicItemStore.shared.topic(at: indexPath.row))
        
        cell.didSelectUser = { [weak self] cell in
            
            guard let this = self else {
                return
            }
            
            if let path = tableView.indexPath(for: cell) {
                let topic = TopicItemStore.shared.topic(at: path.row)
//                let uid = topic.author.id
                let author = topic.author
//                this.performSegueWithIdentifier(SegueIdentifier.ToProfileSegue, sender: uid as AnyObject?)
                this.performSegueWithIdentifier(SegueIdentifier.ToProfileSegue, sender: author)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 359
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        performSegueWithIdentifier(SegueIdentifier.ToTopicDetailSegue, sender: nil)
    }
}
