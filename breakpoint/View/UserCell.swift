//
//  UserCell.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/13/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    var checkMarkShown = false
    
    func configureCell(profileImage image: UIImage, email: String, isSelected: Bool) {
        self.profileImg.image = image
        self.emailLbl.text = email
        if isSelected {
            checkImg.isHidden = false
        } else {
            checkImg.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if checkMarkShown == false {
                checkImg.isHidden = false
                checkMarkShown = true
            } else {
                checkImg.isHidden = true
                checkMarkShown = false
            }
        }
    }
}
