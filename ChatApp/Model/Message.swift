//
//  Message.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/17/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation


class Message {
    var id : String
    var content : Content
    var sender : FireUser
    var timeStamp : Date
    
    
    
    init(id : String , content : Content , sender : FireUser , timeStamp : Date) {
        
        self.id = id
        self.content = content
        self.sender = sender
        self.timeStamp = timeStamp
        
        
    }
}




class FireUser : User {
    
}

struct Content {
    
    var type : ContentType
    var content : Any
}

enum ContentType {
    case string
    case video
    case file
    case image
    
}
