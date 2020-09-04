//
//  Group.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/27/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation

class Group  {
    
    var GroupAdmin : FireUser
    var friends : [Friend]
    let timeCreated : Date
    let id : String
    var name : String
    var image :Data
    var messages : [Message]?
    
    init(GroupAdmin : FireUser , id : String , name : String ) {
        
        self.GroupAdmin = GroupAdmin
        self.friends = []
        self.id = id
        self.name = name
        self.timeCreated = Date()
        self.image = Data()
    }
    
    
    
    
    
    
    
}

