//
//  Group.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/14/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import Foundation

class Group {
    public private(set) var groupTitle: String
    public private(set) var groupDescription: String
    public private(set) var key: String
    public private(set) var memberCount: Int
    public private(set) var members: [String]
    
    init(title: String, description: String, key: String, memberCount: Int, members: [String]) {
        self.groupTitle = title
        self.groupDescription = description
        self.key = key
        self.memberCount = memberCount
        self.members = members
    }
}
