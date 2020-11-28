//
//  Admin.swift
//  ChatApp
//
//  Created by Ramzi on 6/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation

class Admin: FireUser {

    // So insted of creating an new user for an Admin, we just pass a FireUser as a parameter, then call the function becomeAdmin() to turn the user into an Admin.
    
    init(user: FireUser){
    super.init(userID: user.id, userName: user.name, userEmail: user.email,deviceToken: user.deviceToken, creationDate: user.timeCreated)
        
    // Are values passed by reference or by value ? We will need to discuss this...
    self.messages = user.messages
    self.group = user.group
    self.friends = user.friends
    self.becomeAdmin()
        
    // We neeed a function to delete the original user, as there will two two accounts for the user, a regualar and an Admin
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    
    func becomeAdmin() -> Void {
        
        self.userType = TypeOfUser.admin.rawValue
        
        
    }
}
