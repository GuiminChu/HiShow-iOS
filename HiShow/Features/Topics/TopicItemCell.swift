//
//  TopicItemCell.swift
//  HishowZone
//
//  Created by Chu Guimin on 16/9/6.
//  Copyright © 2016年 Chu Guimin. All rights reserved.
//

import UIKit
import Kingfisher

//protocol TapImageViewDelegate {
//    func tapImageView(_ images: [SKPhoto])
//}

extension UIView {
    private func kt_addCorner(radius: CGFloat,
                              borderWidth: CGFloat,
                              backgroundColor: UIColor,
                              borderColor: UIColor) {
        let image = kt_drawRectWithRoundedCorner(radius: radius,
                                                 borderWidth: borderWidth,
                                                 backgroundColor: backgroundColor,
                                                 borderColor: borderColor)
        
        let imageView = UIImageView(image: image)
        self.insertSubview(imageView, at: 0)
    }
    
    private func kt_drawRectWithRoundedCorner(radius: CGFloat,
                                              borderWidth: CGFloat,
                                              backgroundColor: UIColor,
                                              borderColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setAlpha(1)
        context?.setFillColor(backgroundColor.cgColor)
        context?.fill(self.bounds)
        let maskPath = UIBezierPath.init(roundedRect: self.bounds.insetBy(dx: 1, dy: 1), cornerRadius: radius)
        context?.setStrokeColor(borderColor.cgColor)
        maskPath.stroke()
        maskPath.lineWidth = borderWidth
        context?.addPath(maskPath.cgPath)
        context?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output!
    }
    
    func cornerRadius(_ radius: CGFloat, borderWidth: CGFloat = 0, backgroundColor: UIColor = .clear, borderColor: UIColor = .clear) {
        self.kt_addCorner(radius: radius, borderWidth: borderWidth, backgroundColor: backgroundColor, borderColor: borderColor)
    }
    
}

final class TopicItemCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topicImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    
//    var images = [SKPhoto]()
    
//    var delegate: TapImageViewDelegate?
    
    @IBOutlet weak var containerView: UIView!
    var didSelectUser: ((_ cell: TopicItemCell) -> Void)?
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
        let avatarGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar(_:)))
        avatarImageView.addGestureRecognizer(avatarGestureRecognizer)
        
        selectionStyle = .none
        containerView.cornerRadius(10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        topicImageView.image = nil
        avatarImageView.image = nil
    }
    
    func configure(_ topicInfo: Topic) {
        
        nameLabel.text = topicInfo.author.name
        titleLabel.text = topicInfo.title
        likeCountLabel.text = "\(topicInfo.likeCount!)"
        
        if let photoAlt = topicInfo.photos.first?.alt, let url = URL(string: photoAlt) {
            topicImageView.kf.setImage(with: url, options: [KingfisherOptionsInfoItem.transition(ImageTransition.fade(0.25))])
        }
        
        if let urlString = topicInfo.author.avatar, let url = URL(string: urlString) {
            
            let optionsInfo = [KingfisherOptionsInfoItem.transition(ImageTransition.fade(0.25)),
                               KingfisherOptionsInfoItem.processor(RoundCornerImageProcessor(cornerRadius: 16))]
            
            avatarImageView.kf.setImage(with: url, options: optionsInfo)
//            avatarImageView.navi_setAvatar(RoundAvatar(avatarURL: url, avatarStyle: picoAvatarStyle), withFadeTransitionDuration: 0.25)
        }
        
//        for topicPhotoInfo in topicInfo.photos {
//            let photo = SKPhoto.photoWithImageURL(topicPhotoInfo.alt!)
//            photo.shouldCachePhotoURLImage = false
//            images.append(photo)
//        }
    }

    @objc func didTapAvatar(_ recognizer: UITapGestureRecognizer) {
        didSelectUser?(self)
    }
}
