//
//  Chat.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/22/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation


struct Chat  {
    
    var chatType : ChatType
    var ChatInfo : String
    
    
}

enum ChatType {
    case user
    case group
}
