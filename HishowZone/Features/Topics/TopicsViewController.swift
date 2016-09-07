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

        tableView.register(TopicItemCell)
        
        // tableViewCell 自动计算高度
//        self.tableView.estimatedRowHeight = 421.0
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        initMJRefresh()
    }
    
    // 初始化 MJRefresh
    func initMJRefresh() {
        // 下拉刷新
        let mjHeader = MJRefreshNormalHeader {
            
            //  进入刷新状态后执行
            self.startIndex = 0
            
            HiShowAPI.sharedInstance.getTopics(start: self.startIndex,
                completion: { topicModel in
                    self.topics = topicModel.topics
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.resetNoMoreData()
                }, failureHandler: { (reason, errorMessage) in
                    
            })
        }
        // 隐藏时间
        mjHeader.lastUpdatedTimeLabel?.hidden = true
        // 字体颜色
        mjHeader.stateLabel?.textColor = UIColor.lightGrayColor()
        tableView.mj_header = mjHeader
        
        // 马上进入刷新状态
        tableView.mj_header.beginRefreshing()
        
        // 上拉加载更多
        let mjFooter = MJRefreshBackNormalFooter {
            self.startIndex += 20
            
            HiShowAPI.sharedInstance.getTopics(start: self.startIndex,
                completion: { topicModel in
                    self.topics += topicModel.topics
                    self.tableView.mj_footer.endRefreshing()
                
                }, failureHandler: { (reason, errorMessage) in
                    
            })
        }
        tableView.mj_footer = mjFooter
    }
}

// MARK: - Navigation

extension TopicsViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segueIdentifierForSegue(segue) {
        case .ToProfileSegue:
            print("ToProfileSegue")
        case .ToTopicDetailSegue:
            print("ToTopicDetailSegue")
        }
    }
}

// MARK: - Table view data source

extension TopicsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TopicItemCell.reuseIdentifier, forIndexPath: indexPath) as! TopicItemCell
        
        
        
        // Configure the cell
        cell.configure(topics[indexPath.row])
        
        cell.didSelectUser = { [weak self] cell in
            
            guard let this = self else {
                return
            }
            
            this.performSegueWithIdentifier(SegueIdentifier.ToProfileSegue, sender: self)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 326
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        print(indexPath.row)
        performSegueWithIdentifier(SegueIdentifier.ToTopicDetailSegue, sender: self)
    }
}
