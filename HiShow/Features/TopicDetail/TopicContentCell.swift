//
//  TopicContentCell.swift
//  HishowZone
//
//  Created by Chu Guimin on 16/9/12.
//  Copyright © 2016年 Chu Guimin. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

class TopicContentCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    func configure(_ contentString: String?) {
        
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
            for (offset, insertIndex) in tuples.1.enumerated() {
                attributedText.insert(NSAttributedString(attachment: imageAttachment), at: insertIndex + offset)
            }
            
            contentLabel.attributedText = attributedText
        }
    }
    
    func handleContentString(_ str: String) -> (String, [Int]) {
        
        var indexArray = [Int]()
        guard let _ = str.range(of: "<图片") else {
            return (str, indexArray)
        }
        
        var range = str.range(of: "<图片")
        // 删除文本中的换行符"\r"
        var result = str.replacingOccurrences(of: "\r", with: "")
        
        repeat {
            // Swift3 distance(from: startIndex, to: index)
            indexArray.append(result.characters.distance(from: result.startIndex, to: range!.lowerBound))
            
            // 从 "<图片1" 后面的字符串中检索 ">"
            let r = Range(range!.lowerBound..<result.endIndex)
            // <图片1> 右侧 ">" 的 Range
            let rightRange = result.range(of: ">", options: NSString.CompareOptions.caseInsensitive, range: r)
            // <图片1> 的 Range
            let picRange = Range(range!.lowerBound..<rightRange!.upperBound)
            result = result.replacingCharacters(in: picRange, with: "\n")
            
            range = result.range(of: "<图片")
        } while range != nil
        
        return (result, indexArray)
    }
}
