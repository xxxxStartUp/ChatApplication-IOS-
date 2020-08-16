//
//  FireUser.swift
//  ChatApp
//
//  Created by Ramzi on 6/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation


class FireUser : User {
    
    /*
    Constant values for the 'id', 'name', 'email', and 'timeCreated'.
    Variables for 'messages', 'group', 'friends', 'userType' property as they will likely change.
     */
    let name: String
    let id: String // I think this should be an Int as it would be easier to use an ID that is a number to quickly find or refer to a user.
    let email: String
    let timeCreated: Date
    
    var messages: [Message]
    var group: [String]
    var friends: [Friend]
    var userType: Int
    
    
    // When creating a user, these properties will need to be provided
    init(userID: String, userName: String, userEmail: String, creationDate: Date) {
        
        id = userID
        name = userName
        email = userEmail
        timeCreated = creationDate
        messages = []
        group = []
        friends = []
        userType = TypeOfUser.regular.rawValue // I created an enum where 0 would be a regular user and 1 would be an admin user.
        super.init()
    }
    
    var asAFriend : Friend {
        
        return Friend(email: self.email, username: self.name, id: self.id)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func isAdmin() -> Bool {
        
        self.userType == TypeOfUser.admin.rawValue ? true:false
    }
    
    
    
}

enum TypeOfUser: Int {
    case regular = 0
    case admin = 1
}

