//
//  CTDisplayView.swift
//  HiShow
//
//  Created by Chu Guimin on 17/3/8.
//  Copyright © 2017年 cgm. All rights reserved.
//

import UIKit
import Kingfisher

class CTDisplayView: UIView {

    var data: CoreTextData?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 获取绘图上下文
        let context = UIGraphicsGetCurrentContext()!
        
        // 翻转坐标系。对于底层的绘制引擎来说，屏幕的左下角是(0, 0)坐标。而对于上层的 UIKit 来说，左上角是(0, 0)坐标。
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: self.bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        if data != nil {
            CTFrameDraw(data!.ctFrame, context)
            
            for imageData in data!.imageArray {
                
                if let imageName = imageData.name {
                    imageData.image = UIImage(named: imageName)
                } else if let imageUrl = imageData.imageUrl {
                    // 网络图片的绘制也很简单如果没有下载,使用图占位，然后去下载，下载好了重绘就OK了.
                    if imageData.image == nil {
                        imageData.image = UIImage(named:"Image") //灰色图片占位
                        
                        if let url = URL(string: imageUrl) {
                            
                            /*
                            let request = URLRequest(url: url)
                            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                                if let data = data {
                                    DispatchQueue.main.sync {
                                        imageData.image = UIImage(data: data)
                                        self.setNeedsDisplay()  // 下载完成后重绘
                                        print("h3")
                                    }
                                }
                            }).resume()
                            */
                            
                            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                                
                                imageData.image = image
                                
                                
                                self.setNeedsDisplay()
                            })
                        }
                    }
                }
                
                context.draw(imageData.image!.cgImage!, in: imageData.imagePosition)
            }
        }
    }
}
