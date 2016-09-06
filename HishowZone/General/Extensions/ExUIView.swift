//
//  ExUIView.swift
//  HishowZone
//
//  Created by Chu Guimin on 16/9/6.
//  Copyright © 2016年 Chu Guimin. All rights reserved.
//

import Foundation

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(self)
    }
}

protocol NibLoadableView: class {}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(self)
    }
}

extension UITableViewCell: ReusableView, NibLoadableView {}

extension UITableView {
    func register<T: UITableViewCell where T: ReusableView, T: NibLoadableView>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        registerNib(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
}
