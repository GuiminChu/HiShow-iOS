//
//  TopicDetailCell.swift
//  HiShow
//
//  Created by Chu Guimin on 17/2/28.
//  Copyright © 2017年 cgm. All rights reserved.
//

import UIKit

class TopicDetailCell: UITableViewCell {

    @IBOutlet weak var displayView: CTDisplayView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var displayViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        print(displayView.bounds.size.width)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(topic: Topic) {
         print(displayView.bounds.size.width)
        
        var config = CTFrameParserConfig()
        config.width = displayViewWidth.constant
        let data = CTFrameParser.parseTemplateFile(topic: topic, config: config)
        
        for imageData in data.imageArray {
            print(imageData.imagePosition)
        }
        
        print(data.height)
        height.constant = data.height
        
        displayView.data = data
    }
    
}
