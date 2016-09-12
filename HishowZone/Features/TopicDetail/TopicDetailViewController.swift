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
        
        tableView.register(TopicContentCell)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension TopicDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TopicContentCell.reuseIdentifier, forIndexPath: indexPath) as! TopicContentCell
        
        // Configure the cell
        cell.configure(topic?.content)
    
        
        return cell
    }
}
