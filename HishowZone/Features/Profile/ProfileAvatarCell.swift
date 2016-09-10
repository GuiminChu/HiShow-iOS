//
//  ProfileAvatarCell.swift
//  HishowZone
//
//  Created by Chu Guimin on 16/9/6.
//  Copyright © 2016年 Chu Guimin. All rights reserved.
//

import UIKit

class ProfileAvatarCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(largeAvatarUrl: String?) {
        
        if let urlString = largeAvatarUrl, url = NSURL(string: urlString) {
            avatarImageView.navi_setAvatar(RoundAvatar(avatarURL: url, avatarStyle: miniAvatarStyle), withFadeTransitionDuration: 0.25)
        }
    }
}
