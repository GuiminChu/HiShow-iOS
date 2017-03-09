//
//  TopicsViewController.swift
//  HishowZone
//
//  Created by Chu Guimin on 16/9/6.
//  Copyright © 2016年 Chu Guimin. All rights reserved.
//

import UIKit

class TopicsViewController: UIViewController, SegueHandlerType {

    enum SegueIdentifier: String {
        case ToProfileSegue
        case ToTopicDetailSegue
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var topics = [Topic]() {
        didSet {
            if topics.count > 0 {
                tableView.reloadData()
            }
        }
    }
    
    /// 分页参数，第一页为0
    var startIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 定义子界面返回键的文字文本
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)

        tableView.register(TopicItemCell.self)
        
        initMJRefresh1()
    }
    
    func initMJRefresh1(){
        let mjHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(pullToRefresh))
        mjHeader?.lastUpdatedTimeLabel!.isHidden = true
        tableView.mj_header = mjHeader
        tableView.mj_header.beginRefreshing()
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(pullToLoadMore))
    }
    
    func pullToRefresh() {
        //  进入刷新状态后执行
        startIndex = 0
        
        HiShowAPI.sharedInstance.getTopics(start: startIndex,
                                           completion: { [weak self] topicModel in
                                            
                                            guard let strongSelf = self else { return }
                                            
                                            strongSelf.topics = topicModel.topics
                                            strongSelf.tableView.mj_header.endRefreshing()
                                            strongSelf.tableView.mj_footer.resetNoMoreData()
            }, failureHandler: { (reason, errorMessage) in
                
        })
    }
    
    func pullToLoadMore() {

        startIndex += 20
        
        HiShowAPI.sharedInstance.getTopics(start: startIndex,
                                           completion: { [weak self] topicModel in
                                            
                                            guard let strongSelf = self else { return }
                                            
                                            strongSelf.topics += topicModel.topics
                                            strongSelf.tableView.mj_footer.endRefreshing()
                                            
            }, failureHandler: { (reason, errorMessage) in
                
        })
    }
    
    // 初始化 MJRefresh
    func initMJRefresh() {
        // 下拉刷新
        let mjHeader = MJRefreshNormalHeader {
            
            //  进入刷新状态后执行
            self.startIndex = 0
            
            HiShowAPI.sharedInstance.getTopics(start: self.startIndex,
                completion: { [weak self] topicModel in
                    
                    guard let strongSelf = self else { return }
                    
                    strongSelf.topics = topicModel.topics
                    strongSelf.tableView.mj_header.endRefreshing()
                    strongSelf.tableView.mj_footer.resetNoMoreData()
                }, failureHandler: { (reason, errorMessage) in
                    
            })
        }
        // 隐藏时间
//        mjHeader?.lastUpdatedTimeLabel?.hidden = true
        mjHeader?.lastUpdatedTimeLabel.isHidden = true
        // 字体颜色
        mjHeader?.stateLabel.textColor = UIColor.lightGray
        tableView.mj_header = mjHeader
        
        // 马上进入刷新状态
        tableView.mj_header.beginRefreshing()
        
        // 上拉加载更多
        let mjFooter = MJRefreshBackNormalFooter {
            self.startIndex += 20
            
            HiShowAPI.sharedInstance.getTopics(start: self.startIndex,
                completion: { [weak self] topicModel in
                    
                    guard let strongSelf = self else { return }
                    
                    strongSelf.topics += topicModel.topics
                    strongSelf.tableView.mj_footer.endRefreshing()
                
                }, failureHandler: { (reason, errorMessage) in
                    
            })
        }
        tableView.mj_footer = mjFooter
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
            
            let controller = segue.destination as! TopicDetailViewController
            controller.topic = topics[sender as! Int]
        }
    }
}

// MARK: - Table view data source

extension TopicsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TopicItemCell.reuseIdentifier, for: indexPath) as! TopicItemCell
        
        // Configure the cell
        cell.configure(topics[indexPath.row])
        
        cell.didSelectUser = { [weak self] cell in
            
            guard let this = self else {
                return
            }
            
            if let path = tableView.indexPath(for: cell) {
                let topic = this.topics[path.row]
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
        
        performSegueWithIdentifier(SegueIdentifier.ToTopicDetailSegue, sender: indexPath.row)
    }
}
