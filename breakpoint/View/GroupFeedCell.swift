//
//  GroupFeedCell.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/17/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    func configureCell(image: UIImage, email: String, content: String) {
        profileImage.image = image
        emailLbl.text = email
        contentLbl.text = content
    }
}
