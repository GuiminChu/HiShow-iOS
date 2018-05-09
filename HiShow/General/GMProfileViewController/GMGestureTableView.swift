//
//  GMGestureTableView.swift
//
//  Created by Chu Guimin on 2018/5/8.
//  Copyright © 2018年 Chu Guimin. All rights reserved.
//

import UIKit

class GMGestureTableView: UITableView, UIGestureRecognizerDelegate {
    // 底层tableView实现这个 UIGestureRecognizerDelegate 的方法，从而可以接收并响应上层tabelView的滑动手势，otherGestureRecognizer就是它上层View也持有的Gesture，这里在它上层的有scrollView和顶层tableView
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // 保证其它手势的View存在
        guard let otherView = otherGestureRecognizer.view else {
            return false
        }
        
        // 如果其它手势的View是scrollView的手势，肯定是不能同时响应的
        if otherView.isMember(of: UIScrollView.self) {
            return false
        }
        
        // 其它手势是collectionView 或者tableView的pan手势 ，那么就让它们同时响应
        let isPan = gestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
        
        if isPan && otherView.isKind(of: UIScrollView.self) {
            return true
        }
        
        return false
    }
}
