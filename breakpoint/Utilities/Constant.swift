//
//  Constant.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 11/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import Foundation

// UserDefaults
let USER_IMAGE_URL = UserDefaults.standard.string(forKey: "userImageUrl")
let USER_IMAGE_DATA = UserDefaults.standard.data(forKey: "userImageData")

// Notifaction
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataDidChange")
let NOTIF_USER_CHOOSE_DEFAULT_PROFILE = Notification.Name("notifUserChooseDefaultProfile")

