//
//  TopicDetailViewController.swift
//  HishowZone
//
//  Created by Chu Guimin on 16/9/12.
//  Copyright © 2016年 Chu Guimin. All rights reserved.
//

import UIKit

class TopicDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var topic: Topic?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        // tableViewCell 自动计算高度
        tableView.estimatedRowHeight = 88.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
//        tableView.register(TopicContentCell.self)
        tableView.register(TopicDetailCell.self)

    }
}

extension TopicDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: TopicContentCell.reuseIdentifier, for: indexPath) as! TopicContentCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TopicDetailCell.reuseIdentifier, for: indexPath) as! TopicDetailCell
        
        // Configure the cell
        cell.configure(topic: topic!)
    
        return cell
    }
}
