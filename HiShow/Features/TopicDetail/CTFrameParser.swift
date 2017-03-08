//
//  CTFrameParser.swift
//  HiShow
//
//  Created by Chu Guimin on 17/3/8.
//  Copyright © 2017年 cgm. All rights reserved.
//

import UIKit

class CTFrameParser: NSObject {
    
    /// 解析模板文件
    class func parseTemplateFile(topic: Topic, config: CTFrameParserConfig) -> CoreTextData {
        var imageArray = [CoreTextImageData]()
//        var linkArray  = [CoreTextLinkData]()
        
        let content = self.loadTopicTuples(topic: topic, config: config, imageArray: &imageArray)
        
        let coreTextData = self.parse(content: content, config: config)
        
        coreTextData.imageArray = imageArray
//        coreTextData.linkArray = linkArray
        
        return coreTextData
    }
    
    private static func parseTopicContentString(_ str: String) -> (String, [Int]) {
        
        var indexArray = [Int]()
        guard let _ = str.range(of: "<图片") else {
            return (str, indexArray)
        }
        
        // 删除文本中的换行符"\r" (注：\r不占用字符)
        var result = str.replacingOccurrences(of: "\r", with: "")
        
        while let range = result.range(of: "<图片") {
            indexArray.append(result.characters.distance(from: result.startIndex, to: range.lowerBound))
            
            // 从 "<图片1" 后面的字符串中检索 ">"
            let r = Range(range.lowerBound..<result.endIndex)
            // <图片1> 右侧 ">" 的 Range
            let rightRange = result.range(of: ">", options: NSString.CompareOptions.caseInsensitive, range: r)
            // <图片1> 的 Range
            let picRange = Range(range.lowerBound..<rightRange!.upperBound)
            result = result.replacingCharacters(in: picRange, with: "\n\n")
        }
        
        return (result, indexArray)
    }
    
    /// 加载模板文件
    class func loadTopicTuples(topic: Topic, config: CTFrameParserConfig, imageArray: inout [CoreTextImageData]) -> NSAttributedString {
        
        let result = NSMutableAttributedString()
        
        if let content = topic.content {
            
            print(content)
            let tuples = parseTopicContentString(content)
            print(tuples)
            
            // 处理文本
            let attributes = self.attributes(config: config)
            result.append(NSAttributedString(string: tuples.0, attributes: attributes))
            
            // 处理图片
            // insertIndex 记录需要插入图片的原始位置，插入一张图片后(图片占一个字符)原始位置向右偏移一位才是真实位置
            for (offset, insertIndex) in tuples.1.enumerated() {
                
                let photoInfo = topic.photos[offset]
                
                let imageData = CoreTextImageData()
                imageData.title = photoInfo.title
                imageData.imageUrl = photoInfo.alt
                imageData.imagePosition = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
                imageArray.append(imageData)
                
//                addCTRunDelegateWith(imageStr: UrlImageName, indentifier: UrlImageName, insertIndex: insertIndex + offset, attribute: mutableAttributeString)
                let subStr = self.parseImageAttributedCotnent(photoInfo: photoInfo, config: config)
//                result.append(subStr)
                result.insert(subStr, at: insertIndex + offset + 1)
            }
        }

        return result
    }
    
    static func parse(content: NSAttributedString, config: CTFrameParserConfig) -> CoreTextData {
        // 创建 CTFramesetter 实例
        let framesetter = CTFramesetterCreateWithAttributedString(content)
        
        // 获取要绘制的区域的高度
        let restrictSize = CGSize(width: config.width, height: CGFloat.greatestFiniteMagnitude)
        let coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil)
        let textHeight = coreTextSize.height
        
        // 生成 CTFrame 实例
        let frame = self.creatFrame(framesetter: framesetter, config: config, height: textHeight)
        
        // 将生成的 CTFrame 实例和计算好的绘制高度保存到 CoreTextData 实例中
        let data = CoreTextData(ctFrame: frame, height: textHeight)
        
        // 返回 CoreTextData 实例
        return data
    }
    
    class func creatFrame(framesetter: CTFramesetter, config: CTFrameParserConfig, height: CGFloat) -> CTFrame {
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: config.width, height: height))
        
        return CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
    }
    
    /// 配置文字信息
    ///
    /// - Parameter config: 配置信息
    /// - Returns: 文字基本属性
    class func attributes(config: CTFrameParserConfig) -> [String: Any] {
        // 字体大小
        let fontSize = config.fontSize
        let uiFont = UIFont.systemFont(ofSize: fontSize)
        let ctFont = CTFontCreateWithName(uiFont.fontName as CFString?, fontSize, nil)
        // 字体颜色
        let textColor = config.textColor
        
        // 行间距
        var lineSpacing = config.lineSpace
        
        let settings = [
            CTParagraphStyleSetting(spec: .lineSpacingAdjustment, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpacing),
            CTParagraphStyleSetting(spec: .maximumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpacing),
            CTParagraphStyleSetting(spec: .minimumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpacing)
        ]
        let paragraphStyle = CTParagraphStyleCreate(settings, settings.count)
        
        // 封装
        let dict: [String: Any] = [
            NSForegroundColorAttributeName: textColor,
            NSFontAttributeName: ctFont,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        return dict
    }
    
    
    class PictureRunInfo {
        
        var ascender: CGFloat
        var descender: CGFloat
        var width: CGFloat
        
        init(ascender: CGFloat, descender: CGFloat, width: CGFloat) {
            self.ascender = ascender
            self.descender = descender
            self.width = width
        }
    }
    
    /// 从字典中解析图片富文本信息
    ///
    /// - Parameters:
    ///   - dict: 文字属性字典
    ///   - config: 配置信息
    /// - Returns: 图片富文本
    class func parseImageAttributedCotnent(photoInfo: Photo, config: CTFrameParserConfig) -> NSAttributedString {
        
        let imageWidth = config.width
        let imageHeight = CGFloat(photoInfo.size.height) / CGFloat(photoInfo.size.width) * imageWidth
        
        let ascender = imageHeight
        let width = imageWidth
        let pic = PictureRunInfo(ascender: ascender, descender: 0.0, width: width)
        
        var callbacks = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { refCon in
            print("RunDelegate dealloc!")
        }, getAscent: { (refCon) -> CGFloat in
            let pictureRunInfo = unsafeBitCast(refCon, to: PictureRunInfo.self)
            return pictureRunInfo.ascender
        }, getDescent: { (refCon) -> CGFloat in
            return 0
        }, getWidth: { (refCon) -> CGFloat in
            let pictureRunInfo = unsafeBitCast(refCon, to: PictureRunInfo.self)
            return pictureRunInfo.width
        })
        
        
        let selfPtr = UnsafeMutableRawPointer(Unmanaged.passRetained(pic).toOpaque())
        
        //1:设置CTRun的代理,为图片设置CTRunDelegate,delegate决定留给图片的空间大小
        // 创建 RunDelegate, 传入 imageCallback 中图片数据
        let runDelegate = CTRunDelegateCreate(&callbacks, selfPtr)
        
//        let replaceChar = 0xFFFC
//        let content = String(replaceChar)
//        let attributes = self.attributes(config: config)
//        let space = NSMutableAttributedString(string: " ", attributes: attributes)
        
        
        let imageAttributedString = NSMutableAttributedString(string: " ")
        imageAttributedString.addAttribute(kCTRunDelegateAttributeName as String, value: runDelegate!, range: NSMakeRange(0, 1))
        
//        CFAttributedStringSetAttribute(space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, runDelegate)
        
        
        //2 为每个图片创建一个空的string占位
//        let imageAttributedString = NSMutableAttributedString(string: " ")
//        imageAttributedString.addAttribute(kCTRunDelegateAttributeName as String, value: runDelegate!, range: NSMakeRange(0, 1))
//        
//        //3:添加属性，在CTRun中可以识别出这个字符是图片
//        //        imageAttributedString.addAttribute(indentifier, value: imageName, range: NSMakeRange(0, 1))
//        //4:在index处插入图片
//        attribute.insert(imageAttributedString, at: insertIndex)
        
        
        return imageAttributedString
    }
}
