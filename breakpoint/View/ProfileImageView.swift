//
//  ProfileImageView.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/20/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {
    override func awakeFromNib() {
        // Make circle image
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
        
        super.awakeFromNib()
    }
}
