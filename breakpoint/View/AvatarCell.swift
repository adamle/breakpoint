//
//  AvatarCell.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/19/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    func configureCell(index: Int) {
        avatarImage.image = UIImage(named: "proLang\(index)")
    }
    
    func setupView() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
}
