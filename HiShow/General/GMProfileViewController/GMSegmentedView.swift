//
//  GMSegmentedView.swift
//
//  Created by Chu Guimin on 2018/5/8.
//  Copyright © 2018年 Chu Guimin. All rights reserved.
//

import UIKit

class GMSegmentedView: UIView {
    
    public var segmentedControl: SegmentedControl!
    
    fileprivate lazy var defaultTitles: [String] = {
        return ["First", "Second"]
    }()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        self.configureNavigationTitleSegmentedControl(titleStrings: defaultTitles)
//    }
    
    public init(frame: CGRect, titles: [String]) {
        super.init(frame: frame)
        
        self.configureNavigationTitleSegmentedControl(titleStrings: titles)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        self.configureNavigationTitleSegmentedControl(titleStrings: defaultTitles)
    }
    
}

extension GMSegmentedView {
    
    fileprivate func configureNavigationTitleSegmentedControl(titleStrings: [String]) {
        let titles: [NSAttributedString] = {
            let attributes: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]
            var titles = [NSAttributedString]()
            for titleString in titleStrings {
                let title = NSAttributedString(string: titleString, attributes: attributes)
                titles.append(title)
            }
            return titles
        }()
        let selectedTitles: [NSAttributedString] = {
            let attributes: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)]
            var selectedTitles = [NSAttributedString]()
            for titleString in titleStrings {
                let selectedTitle = NSAttributedString(string: titleString, attributes: attributes)
                selectedTitles.append(selectedTitle)
            }
            return selectedTitles
        }()
        segmentedControl = SegmentedControl.initWithTitles(titles, selectedTitles: selectedTitles)
        //        segmentedControl.delegate = self
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
        segmentedControl.selectionIndicatorStyle = .bottom
        segmentedControl.selectionIndicatorColor = UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)
        segmentedControl.selectionIndicatorHeight = 3
        //        segmentedControl.segmentSpacing = 5
        segmentedControl.minimumSegmentWidth = 375.0 / 4.0
        //        segmentedControl.segmentWidth = 65
        segmentedControl.frame = self.bounds
        //        segmentedControl.frame.origin.y = UIApplication.shared.statusBarFrame.height + 44
        //        segmentedControl.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 40)
        //        view.insertSubview(segmentedControl, belowSubview: navigationController!.navigationBar)
        self.addSubview(segmentedControl)
        
        // 添加底部分割线
        let lineView = UIView()
        lineView.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        lineView.frame = CGRect(x: 0, y: self.bounds.size.height - 1, width: self.bounds.size.width, height: 1)
        self.addSubview(lineView)
    }
}
