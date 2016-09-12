//
//  TopicContentCell.swift
//  HishowZone
//
//  Created by Chu Guimin on 16/9/12.
//  Copyright © 2016年 Chu Guimin. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.mainScreen().bounds.width
let kScreenHeight = UIScreen.mainScreen().bounds.height

class TopicContentCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    func configure(contentString: String?) {
        
        if let content = contentString {
            
            let tuples = handleContentString(content)
            
            let stringOnly = tuples.0

            let attributedText = NSMutableAttributedString(string: stringOnly)
            
            // 图片附件
            let imageAttachment = NSTextAttachment()
            let image = UIImage(named: "Image")
            imageAttachment.image = image
            
            let imageWidth = kScreenWidth - 16
            let imageHeight = image!.size.height / image!.size.width * imageWidth
            imageAttachment.bounds = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
            
            // insertIndex 记录需要插入图片的原始位置，插入一张图片后(图片占一个字符)原始位置向右偏移一位才是真实位置
            for (offset, insertIndex) in tuples.1.enumerate() {
                attributedText.insertAttributedString(NSAttributedString(attachment: imageAttachment), atIndex: insertIndex + offset)
            }
            
            contentLabel.attributedText = attributedText
        }
    }
    
    func handleContentString(str: String) -> (String, [Int]) {
        
        var indexArray = [Int]()
        guard let _ = str.rangeOfString("<图片") else {
            return (str, indexArray)
        }
        
        var range = str.rangeOfString("<图片")
        // 删除文本中的换行符"\r"
        var result = str.stringByReplacingOccurrencesOfString("\r", withString: "")
        
        repeat {
            // Swift3 distance(from: startIndex, to: index)
            indexArray.append(result.startIndex.distanceTo(range!.startIndex))
            
            // 从 "<图片1" 后面的字符串中检索 ">"
            let r = Range(range!.startIndex..<result.endIndex)
            // <图片1> 右侧 ">" 的 Range
            let rightRange = result.rangeOfString(">", options: NSStringCompareOptions.CaseInsensitiveSearch, range: r)
            // <图片1> 的 Range
            let picRange = Range(range!.startIndex..<rightRange!.endIndex)
            result = result.stringByReplacingCharactersInRange(picRange, withString: "\n")
            
            range = result.rangeOfString("<图片")
        } while range != nil
        
        return (result, indexArray)
    }
}
