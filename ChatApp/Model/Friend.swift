//
//  Friend.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/27/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation

// Since we are making a Friend class, we need to inherit Equatable to be able to compare  two friends objects. I added it here, with the == operator function. Now two Friends objects are 'equal' if they have the same email address.
class Friend : User, Equatable {
    static func == (lhs: Friend, rhs: Friend) -> Bool {
        return lhs.email == rhs.email
    }
    
    
    let email : String
    let username : String
    let id : Int
    
    init(email : String , username : String , id : Int) {
        
        self.email = email
        self.username = username
        self.id = id
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    
}
