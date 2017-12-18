//
//  FeedCell.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/13/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var msgContent: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(profileImage: UIImage, email: String, content: String) {
        profileImg.image = profileImage
        userEmail.text = email
        msgContent.text = content
    }
}
