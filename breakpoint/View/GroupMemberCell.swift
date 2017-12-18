//
//  GroupMemberCell.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/18/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class GroupMemberCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var email: UILabel!
    
    func configureCell(image: UIImage, email: String) {
        self.profileImage.image = image
        self.email.text = email
    }
}
