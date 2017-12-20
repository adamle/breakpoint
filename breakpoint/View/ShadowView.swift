//
//  ShadowView.swift
//  Learning from Devslopes Tutorial
//
//  Created by Le Dang Dai Duong on 12/10/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    override func awakeFromNib() {
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        super.awakeFromNib()
    }
}
