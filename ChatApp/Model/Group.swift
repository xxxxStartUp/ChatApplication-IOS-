//
//  Group.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/27/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation

class Group {
    
    var GroupAdmin : FireUser
    var friends : [Friend]
    let timeCreated : Date
    let id : Int
    var name : String
    var image :Data
    
    init(GroupAdmin : FireUser , id : Int , name : String ) {
        
        self.GroupAdmin = GroupAdmin
        self.friends = []
        self.id = id
        self.name = name
        self.timeCreated = Date()
        self.image = Data()
    }
    
    
    
    
    
    
    
}

