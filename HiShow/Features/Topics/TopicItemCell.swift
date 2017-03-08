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

final class TopicItemCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topicImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    
//    var images = [SKPhoto]()
    
//    var delegate: TapImageViewDelegate?
    
    var didSelectUser: ((_ cell: TopicItemCell) -> Void)?
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
        let avatarGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar(_:)))
        avatarImageView.addGestureRecognizer(avatarGestureRecognizer)
        
        selectionStyle = .none
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
            topicImageView.kf_setImage(with: url, options: [KingfisherOptionsInfoItem.transition(ImageTransition.fade(0.25))])
        }
        
        if let urlString = topicInfo.author.avatar, let url = URL(string: urlString) {
            avatarImageView.navi_setAvatar(RoundAvatar(avatarURL: url, avatarStyle: picoAvatarStyle), withFadeTransitionDuration: 0.25)
        }
        
//        for topicPhotoInfo in topicInfo.photos {
//            let photo = SKPhoto.photoWithImageURL(topicPhotoInfo.alt!)
//            photo.shouldCachePhotoURLImage = false
//            images.append(photo)
//        }
    }

    func didTapAvatar(_ recognizer: UITapGestureRecognizer) {
        didSelectUser?(self)
    }
}
