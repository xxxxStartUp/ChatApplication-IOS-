//
//  Activity.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 7/3/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation

protocol Messaging {
    
}


class Activity {
    
    var type : ActivityType
    var name : String
    
    init(activityType : ActivityType) {
        self.type = activityType
        
        switch type {
      
        case .GroupChat(group: let group):
            self.name = group.name
            break
        case .FriendChat(friend: let friend):
            self.name = friend.username
            break
        }
        
    }
    
    

}


enum ActivityType {
    case GroupChat(group : Group)
    case FriendChat(friend : Friend)
    
}


struct codableUser  : Codable{
    
    var id : String? = nil
    var name : String
    var codableMessage : CodableMessage
    
    init(name: String , message : CodableMessage) {
        self.name = name
        self.codableMessage = message
    }
    
    

}


struct CodableMessage : Codable {
    
    var message : String
}
