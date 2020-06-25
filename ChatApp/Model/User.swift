//
//  User.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/17/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation

class User {
    

}


class Friend : User {
    
    let email : String
    let username : String
    let id : Int
    
    init(email : String , username : String , id : Int) {
        
        self.email = email
        self.username = username
        self.id = id
        super.init()
    }
    
    
}

class Group {
    
    var GroupAdmin : FireUser
    var friends : [Friend]
    var timeCreated : Date
    var id : Int
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
