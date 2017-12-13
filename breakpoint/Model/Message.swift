//
//  Message.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/12/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import Foundation

class Message {
    // Data encapsulation
    private var _content: String
    private var _senderID: String
    
    var content: String {
        return _content
    }
    
    var senderID: String {
        return _senderID
    }
    
    init(content: String, senderID: String) {
        self._content = content
        self._senderID = senderID
    }
    
}
